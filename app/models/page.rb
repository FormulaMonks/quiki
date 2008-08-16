%w( rdiscount redcloth html_parser acts_as_versioned ).each do |requirement|
  require requirement
end

class Page < ActiveRecord::Base  
  attr_accessible :title, :body, :parser, :section_id

  PATH_REGEX  = '[a-zA-Z\-_0-9]+'
  CODE_THEME  = 'blackboard'
  @@parsers   = { :markdown => RDiscount, :textile => RedCloth, :html => HtmlParser }.freeze

  belongs_to :section
  has_many :code_blocks, :conditions => 'code_blocks.version = #{self.version}'

  validates_presence_of   :path, :title
  validates_format_of     :path, :with => /^#{PATH_REGEX}$/
  validates_exclusion_of  :path, :in => %w( pages sections parsers code_blocks syntaxes )
  validates_associated    :section, :allow_nil => true

  # the page has to have the code block ids in order to render, and the code
  # blocks can't be saved for a new page before saving the page, so saving a
  # new page results in 2 saves: 1 to save the page and 1 to render and save
  # again
  before_save  :render
  after_create :save # 2nd save will call render
  
  acts_as_versioned
  # force open the dynamic Page::Version class created by acts_as_versioned
  class Version < ActiveRecord::Base
    has_many :code_blocks, :finder_sql => 'SELECT * FROM code_blocks WHERE code_blocks.version = #{self.version} AND code_blocks.page_id = #{self.page_id}'
  end
  
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
    
    def parse_code_blocks(content)
      parts = content.scan /(.*?)\n(\-:.*?\n.*?\n\-:.*?)\n(.*)/m
      parts.empty? ? [content] : [parts[0][0], parts[0][1]] + parse_code_blocks(parts[0][2])
    end
  end

  def validate
    if similar = Page.find(:first, :conditions => new_record? ? [ 'path = ?', self.path ] : [ 'path = ? AND id <> ?', self.path, self.id ])
      self.errors.add(:title, "results in same url as #{similar}")
    end
    # TODO: decouple parsing and validations
    parse
    @body_parts.each do |part|     
      part.errors.each { |method, message| self.errors.add(:body, message) } if part.is_a?(CodeBlock) && !part.valid?
    end
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
  
  protected
    def parse
      @body_parts = []

      return nil if body.nil?      

      # Page.parse_dot_blocks(body.dup.gsub(/\r\n/, "\n")).each do |part|
      #   if part =~ /^::.*$/ # part is a DOT block
      #     dot, check = part.scan(/^::\n(.*\n)::(.*?)$/m)[0]
      #     if check
      #       @body_parts << DotBlock.new(:dot => dot)
      #     else
      #       self.errors.add(:body, "has unclosed DOT block")
      #     end
      #   end
      # end

      Page.parse_code_blocks(body.dup.gsub(/\r\n/, "\n")).each do |part|
        if part =~ /^\-:.*$/ # part is a code block
          syntax, code, check = part.scan(/^\-:(.*?)\n(.*\n)\-:(.*?)$/m)[0]
          if syntax == check
            @body_parts << CodeBlock.new(:code => code, :language => syntax, :theme => CODE_THEME)
          else
            self.errors.add(:body, "has mismatched code highlighter block ('#{syntax}' and '#{check}')")
          end
        else
          @body_parts << part
        end
      end
    end

    def render
      return self.rendered = '' if new_record? || body.nil?

      self.rendered = []

      @body_parts.each do |body_part|
        if body_part.is_a?(CodeBlock)
          body_part.version = next_version
          self.code_blocks << body_part
          # TODO: render this from the Haml partial code_blocks/stamp
          self.rendered << "<p class=\"code_stamp\"><span class=\"syntax\">#{body_part.language.humanize}</span><a href=\"/#{path}/code/#{body_part.id}\">View Source</a></p>"
          self.rendered << body_part.highlighted
        else
          self.rendered << Page.render(body_part, parser)
        end
      end
      
      self.rendered = self.rendered.join("\n")
    end
end
