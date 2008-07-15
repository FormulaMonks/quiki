class Section < ActiveRecord::Base
  has_many :pages, :dependent => :nullify
  
  def to_s
    name
  end
end