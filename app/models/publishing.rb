require 'net/http'
require 'net/https'
require 'uri'

# a Publishing is a bit of an awkward name, couldn't think of a nouny way to
# say the act of publishing content
class Publishing < ActiveRecord::Base
  belongs_to :destination
  belongs_to :page_version, :class_name => 'Page::Version'
  
  validates_presence_of :destination_id
  validates_presence_of :page_version
  
  before_create :publish
  
  attr_accessor :response
  
  def publish
    url = URI.parse(destination.url)
    
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == 'https')
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    request = Net::HTTP::Post.new(url.path.blank? ? '/' : url.path)
    request.basic_auth url.user, url.password
    request.set_form_data(Hash[*(page_version.attributes.collect{ |k, v| ["page[#{k}]", v] }.flatten)])
    
    self.response = http.request(request)
  end
end