class V1::OrdersController < ApplicationController
  def index
    orders = current_user.orders
    render json: orders.as_json
  end

  def create
    product = Product.find_by(id: params[:input_product_id])
    calculated_subtotal = product.price * params[:input_quantity].to_i
    calculated_tax = calculated_subtotal * 0.09
    calculated_total = calculated_tax + calculated_subtotal
    order = Order.new(
      user_id: current_user.id,
      product_id: params[:input_product_id],
      quantity: params[:input_quantity],
      subtotal: calculated_subtotal,
      tax: calculated_tax,
      total: calculated_total
    )
    if order.save
      render json: order.as_json
    else
      render json: {errors: order.errors.full_messages}, status: :bad_request
    end
  end
end
