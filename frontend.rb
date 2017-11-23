require "unirest"
require "pp"

puts "Choose an option:"
puts "[1] Show all products"
puts "  [1.1] Show all products that match search terms"
puts "  [1.2] Show all products sorted by price"
puts "[2] Create a product"
puts "[3] Show one product"
puts "[4] Update a product"
puts "[5] Delete a product"

input_option = gets.chomp
if input_option == "1"
  response = Unirest.get("http://localhost:3000/v1/products")
  products = response.body
  pp products
elsif input_option == "1.1"
  print "Enter search terms: "
  input_search_terms = gets.chomp
  response = Unirest.get("http://localhost:3000/v1/products?search=#{input_search_terms}")
  products = response.body
  pp products
elsif input_option == "1.2"
  response = Unirest.get("http://localhost:3000/v1/products?sort_by_price=true")
  products = response.body
  pp products
elsif input_option == "2"
  params = {}
  print "New product name: "
  params[:name] = gets.chomp
  print "New product price: "
  params[:price] = gets.chomp
  print "New product image: "
  params[:image] = gets.chomp
  print "New product description: "
  params[:description] = gets.chomp
  response = Unirest.post("http://localhost:3000/v1/products", parameters: params)
  product = response.body
  if product["errors"]
    puts "No good!"
    p product["errors"]
  else
    puts "All good!"
    pp product
  end
elsif input_option == "3"
  print "Enter a product id: "
  product_id = gets.chomp
  response = Unirest.get("http://localhost:3000/v1/products/#{product_id}")
  product = response.body
  pp product
elsif input_option == "4"
  print "Enter a product id: "
  product_id = gets.chomp
  response = Unirest.get("http://localhost:3000/v1/products/#{product_id}")
  product = response.body
  params = {}
  print "Updated product name (#{product["name"]}): "
  params[:name] = gets.chomp
  print "Updated product price (#{product["price"]}): "
  params[:price] = gets.chomp
  print "Updated product image (#{product["image"]}): "
  params[:image] = gets.chomp
  print "Updated product description (#{product["description"]}): "
  params[:description] = gets.chomp
  params.delete_if { |_key, value| value.empty? }
  response = Unirest.patch("http://localhost:3000/v1/products/#{product_id}", parameters: params)
  product = response.body
  pp response.body
elsif input_option == "5"
  print "Enter a product id: "
  product_id = gets.chomp
  response = Unirest.delete("http://localhost:3000/v1/products/#{product_id}")
  pp response.body
end
