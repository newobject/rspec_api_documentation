require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Orders" do
  resource "OrderItems" do
    header "Accept", "application/json"
    header "Content-Type", "application/json"

    let!(:order) { Order.create(:name => "Order 1", :paid => true, :email => "email@example.com") }

    #get "/orders/#{order.id}/order_items" do
    get "/orders/:order_id/order_items" do
      parameter :page, "Current page of orders"

      let(:page) { 1 }
      let(:order_id) { order.id }

      before do
        2.times do |i|
          order.order_items.create(:name => "Item #{i}", :amount => i)
        end
      end

      example_request "Getting the list of order items of a order" do
        response_body.should == order.order_items.reload.to_json
        status.should == 200
      end
    end
  end
end
