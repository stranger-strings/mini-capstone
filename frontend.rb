require "unirest"
require "pp"

response = Unirest.get("http://localhost:3000/all_products_url")
products = response.body

pp products
