class Product < ApplicationRecord
  def is_discounted
    price.to_f <= 2
  end

  def tax
    price.to_f * 0.09
  end

  def total
    price.to_f + tax
  end

  def as_json
    {
      id: id,
      name: name,
      description: description,
      price: price,
      tax: tax,
      total: total,
      is_discounted: is_discounted,
    }
  end
end
