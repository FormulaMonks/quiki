class Asset < ActiveResource::Base
  self.site = "http://localhost:3001"
  SEPARATOR  = '.'
  THUMBNAIL_PATH = 'images/assets'
  
  def thumbnail(options={})
    append = options.collect{ |k, v| "#{k}=#{v}" }.sort.join('_')
    
    self.class.site.to_s + THUMBNAIL_PATH + '/' + path + '/' +
    File.basename(filename, File.extname(filename)) +
    (append.blank? ? '' : "#{SEPARATOR}#{append}") +
    File.extname(filename)
  end
  
  def to_s
    filename
  end
end