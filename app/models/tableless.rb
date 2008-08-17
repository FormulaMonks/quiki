class Tableless < ActiveRecord::Base
  self.abstract_class = true
  
  class << self
    def columns()
      @columns ||= [];
    end

    def column(name, sql_type = nil, default = nil, null = true)
      columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
    end
  end

  def create
    save
  end
  
  def save(validate = true)
    validate ? valid? : true
  end
end
