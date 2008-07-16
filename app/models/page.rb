%w( rdiscount redcloth html_parser acts_as_versioned code_block ).each do |requirement|
  require requirement
end

class Page < ActiveRecord::Base  
  attr_accessible :title, :body, :parser, :section_id

  PATH_REGEX  = '[a-zA-Z\-_0-9]+'
  CODE_THEME  = 'blackboard'
  @@parsers   = { :markdown => RDiscount, :textile => RedCloth, :html => HtmlParser }.freeze

  belongs_to :section
  # note that CodeBlock has to be loaded before de-serialization for it to work
  serialize :code_blocks

  validates_presence_of   :path, :title
  validates_format_of     :path, :with => /^#{PATH_REGEX}$/
  validates_exclusion_of  :path, :in => %w( pages sections parsers )
  validates_associated    :section, :allow_nil => true

  #before_validation :render
  
  acts_as_versioned
  
  named_scope :without_home, :conditions => [ 'pages.path <> ?', 'Home' ]
  named_scope :orphaned, :conditions => 'pages.section_id IS NULL'
  named_scope :recent, :order => 'pages.updated_at DESC'

  class << self
    # renders the given content to html using the given parser
    def render(content, parser)
      # render content here...
      parser = parser_class(parser).new content
      parser.to_html
    end

    # returns the class associated with the given parser
    def parser_class(name)
      @@parsers[(name || :html).to_sym] || HtmlParser
    end

    def parsers
      @@parsers.collect{ |parser, klass| parser.to_s }.sort
    end
    
    def path(title)
      title.gsub(/#{PATH_REGEX.gsub(/\[/, '[^ ')}/, '').gsub(/\s/, '-')
    end
  end

  def validate
    if similar = Page.find(:first, :conditions => new_record? ? [ 'path = ?', self.path ] : [ 'path = ? AND id <> ?', self.path, self.id ])
      self.errors.add(:title, "results in same url as #{similar}")
    end
    # TODO: decouple rendering and parser validations
    render
  end

  def parser
    self[:parser] || 'markdown'
  end
  
  def title=(title)
    self[:title] = title
    self.path = Page.path(title)
  end

  def to_param
    path
  end

  def to_s
    ERB::Util.h(title)
  end
  
  def current?(version)
    version.version == self.version
  end
  
  private
    def parse_code_blocks(content)
      parts = content.scan /(.*?)\n(\-:.*?\n.*?\n\-:.*?)\n(.*)/m
      parts.empty? ? [content] : [parts[0][0], parts[0][1]] + parse_code_blocks(parts[0][2])
    end
  
    def render
      return self.rendered = '' if body.nil?
      
      body_parts  = [] # haha...get it?
      code_blocks = []
      stripped    = body.dup.gsub(/\r\n/, "\n") # strip carriage returns
      parts       = parse_code_blocks stripped
      
      parts.each do |part|
        if part =~ /^\-:.*$/ # part is a code block
          syntax, code, check = part.scan(/^\-:(.*?)\n(.*\n)\-:(.*?)$/m)[0]
          if syntax == check
            code_blocks << (block = CodeBlock.new(syntax, code))
            body_parts << "<p class=\"code_stamp\"><span class=\"syntax\">#{syntax.humanize}</span><a href=\"/#{path}/code/#{code_blocks.length-1}\">View Source</a></p>"
            begin
              body_parts << block.highlight(CODE_THEME) 
            rescue NoMethodError => e
              if e.message =~ /nil\.parse/
                self.errors.add(:body, "references unknown code highlighter '#{syntax}'")
              else
                raise e
              end
            end
          else
            self.errors.add(:body, "has mismatched code highlighter block ('#{syntax}' and '#{check}')")
          end
        else
          body_parts << Page.render(part, parser)
        end
      end
      
      self.code_blocks = code_blocks
      self.rendered = body_parts.join
    end
end