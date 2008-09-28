class Destination < ActiveRecord::Base
  has_many :publishings
  has_many :page_versions, :through => :publishings do
    def most_recently_published
      find(:first, :include => :publishing, :order => 'publishings.created_at DESC')
    end
  end
  
  validates_presence_of :name
  validates_presence_of :url
  validates_format_of :url, :with => /^.*?:\/\/.*$/
  
  class << self
    def to_select(options={})
      find(:all, options).collect{ |destination| [ destination.name, destination.url ] }
    end
  end
  
  def to_s
    name
  end
  
  def masked_url
    if url =~ /^(.*?)\/\/(.*?):(.+?)@(.*)$/
      "#{$1}//#{$2}:xxx@#{$4}"
    else
      url
    end
  end
end
