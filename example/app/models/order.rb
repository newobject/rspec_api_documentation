class Order < ActiveRecord::Base
  has_many :order_items

  validates :name, :paid, :email, :presence => true

  attr_accessible :name, :paid, :email

  def as_json(opts = {})
    super(:only => [:name, :paid, :email])
  end
end
