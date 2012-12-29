class OrderItem < ActiveRecord::Base
  belongs_to :order

  attr_accessible :name, :amount

  def as_json(opts = {})
    super(:only => [:name, :amount])
  end
end
