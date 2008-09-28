class Destination < ActiveRecord::Base
  has_many :publishings
  has_many :page_versions, :through => :publishings do
    def most_recently_published
      find(:first, :include => :publishing, :order => 'publishings.created_at DESC')
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
