class Product < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true
  has_many :category_products

  has_many :categories, through: :category_products
  # def categories
  #   category_products.map {|category_product| category_product.category}
  # end

  has_many :orders
  belongs_to :supplier
  # def supplier
  #   Supplier.find_by(id: self.supplier_id)
  # end

  has_many :images
  # def images
  #   Image.where(product_id: self.id)
  # end

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
      supplier: supplier.as_json,
      categories: categories.as_json
    }
  end
end
