class CartedProduct < ApplicationRecord
  belongs_to :product
  belongs_to :user
  belongs_to :order, optional: true

  def as_json
    {
      id: id,
      product: product.as_json,
      quantity: quantity
    }
  end
end
