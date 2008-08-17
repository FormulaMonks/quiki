class DotBlock < Tableless
  attr_accessible :code
  
  GRAPH_PATH = File.join(RAILS_ROOT, 'public', 'graphs').freeze
  
  column :code, :string
  
  def render!
    File.open(dot_file, 'w') { |file| file.puts code + "\n" }
    `dot -Tpng -o#{graph_file} #{dot_file}`
    File.unlink(dot_file)
    graph_file.gsub(/^.*public\/(.*)$/, "\\1")
  end
  
  private
    def dot_file
      @dot_file ||= File.join(RAILS_ROOT, 'tmp', "#{Digest::MD5.hexdigest(Time.now.to_s)}.dot")
    end
  
    def graph_file
      @graph_file ||= File.join(GRAPH_PATH, "#{Digest::MD5.hexdigest(Time.now.to_s)}.png")
    end
end
