class Product < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true

  def supplier
    Supplier.find_by(id: self.supplier_id)
  end

  def images
    Image.where(product_id: self.id)
  end

  def is_discounted
    price <= 2
  end

  def tax
    price * 0.09
  end

  def total
    price + tax
  end

  def as_json
    {
      id: id,
      name: name,
      description: description,
      images: images.map { |image| image.url },
      price: price,
      tax: tax,
      total: total,
      is_discounted: is_discounted,
      supplier: supplier.as_json
    }
  end
end
