class Image < Asset
  def remote_path
    "#{self.class.site}images/assets/#{self.thumbnail_path}/#{basename}-crop=false_size=450x.#{extension}"
  end
  
  protected
    def thumbnail_path
      "#{self.path}/#{basename}"
    end
    
    def basename
      File.basename(self.filename, extension)
    end
    
    def extension
      File.extname(self.filename)
    end
end