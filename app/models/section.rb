class Section < ActiveRecord::Base
  has_many :pages
  
  def to_s
    name
  end
end