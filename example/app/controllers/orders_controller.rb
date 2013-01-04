class OrdersController < InheritedResources::Base
  respond_to :json

  def member_demo
    @order = Order.find params[:id]

    respond_with @order
  end

  def collection_demo
    @orders = Order.all

    respond_with @orders
  end
end
