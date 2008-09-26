class Destination < ActiveRecord::Base
  has_many :publishings, :through => :page_versions do
    def latest
      find(:first, :order => 'publishings.created_at DESC')
    end
  end
  
  class << self
    def to_select(options={})
      find(:all, options).collect{ |destination| [ destination.name, destination.url ] }
    end
  end
  
  def to_s
    name
  end
end
