class Post < ActiveRecord::Base
  attr_accessible :content, :name, :title

  def as_json(opts={})
    super(:only => [:name, :title, :content])
  end
end
