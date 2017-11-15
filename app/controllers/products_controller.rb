class ProductsController < ApplicationController
  def all_products_method
    products = Product.all
    render json: products.as_json
  end
end
