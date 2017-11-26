class Supplier < ApplicationRecord
  def products
    Product.where(supplier_id: self.id)
  end

  def as_json
    {
      id: id,
      name: name,
      email: email,
      phone_number: phone_number
    }
  end
end
