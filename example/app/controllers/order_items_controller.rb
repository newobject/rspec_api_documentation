class OrderItemsController < InheritedResources::Base
  respond_to :json

  belongs_to :order
end
