require "unirest"
require "pp"

while true
  system "clear"
  puts "Choose an option:"
  puts "[1] Show all products"
  puts "  [1.1] Show all products that match search terms"
  puts "  [1.2] Show all products sorted by price"
  puts "[2] Create a product"
  puts "[3] Show one product"
  puts "[4] Update a product"
  puts "[5] Delete a product"
  puts
  puts "[6] Add a product to the shopping cart"
  puts "[7] View shopping cart"
  puts
  puts "[signup] Sign up (create a user)"
  puts "[login] Log in (create a jwt)"
  puts "[logout] Log out (destroy the jwt)"
  puts
  puts "[q] Quit"

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
  elsif input_option == "6"
    params = {}
    print "Product id: "
    params[:input_product_id] = gets.chomp
    print "Quantity: "
    params[:input_quantity] = gets.chomp
    response = Unirest.post("http://localhost:3000/v1/carted_products", parameters: params)
    carted_product = response.body
    if carted_product["errors"]
      puts "No good!"
      p carted_product["errors"]
    else
      puts "All good!"
      pp carted_product
    end
  elsif input_option == "7"
    response = Unirest.get("http://localhost:3000/v1/carted_products")
    carted_products = response.body
    pp carted_products
    puts "Press 'o' to order the items, or 'r' to remove a carted product, or enter to continue"
    input_sub_option = gets.chomp
    if input_sub_option == 'o'
      response = Unirest.post("http://localhost:3000/v1/orders")
      order = response.body
      pp order
    elsif input_sub_option == 'r'
      print "Enter the id of the carted product to remove: "
      id = gets.chomp
      response = Unirest.delete("http://localhost:3000/v1/carted_products/#{id}")
      pp response.body
    end
  elsif input_option == "signup"
    print "Enter name: "
    input_name = gets.chomp
    print "Enter email: "
    input_email = gets.chomp
    print "Enter password: "
    input_password = gets.chomp
    print "Confirm password: "
    input_password_confirmation = gets.chomp
    response = Unirest.post(
      "http://localhost:3000/v1/users",
      parameters: {
        name: input_name,
        email: input_email,
        password: input_password,
        password_confirmation: input_password_confirmation
      }
    )
    pp response.body
  elsif input_option == "login"
    print "Enter email: "
    input_email = gets.chomp
    print "Enter password: "
    input_password = gets.chomp
    response = Unirest.post(
      "http://localhost:3000/user_token",
      parameters: {
        auth: {
          email: input_email,
          password: input_password
        }
      }
    )
    jwt = response.body["jwt"]
    Unirest.default_header("Authorization", "Bearer #{jwt}")
    pp response.body
  elsif input_option == "logout"
    jwt = ""
    Unirest.clear_default_headers()
    puts "Logged out successfully!"
  elsif input_option == "q"
    puts "Goodbye!"    
    break
  end
  puts "Press enter to continue"
  gets.chomp
end
