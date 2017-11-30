require "unirest"
require "pp"

class Frontend
  def initialize
    @jwt = ""
  end

  def show_menu
    system "clear"
    puts "Choose an option:"
    puts "[1] Show all products"
    puts "  [1.1] Show all products that match search terms"
    puts "  [1.2] Show all products sorted by price"
    puts "[2] Create a product"
    puts "[3] Show one product"
    puts "[4] Update a product"
    puts "[5] Delete a product"
    puts "[6] Order a product"
    puts "[7] View all orders"
    puts
    puts "[signup] Sign up (create a user)"
    puts "[login] Log in (create a jwt)"
    puts "[logout] Log out (destroy the jwt)"
    puts
    puts "[q] Quit"
  end

  def show_all_products
    response = Unirest.get("http://localhost:3000/v1/products")
    products = response.body
    pp products
  end

  def show_all_products_search
    print "Enter search terms: "
    input_search_terms = gets.chomp
    response = Unirest.get("http://localhost:3000/v1/products?search=#{input_search_terms}")
    products = response.body
    pp products
  end

  def show_all_products_sorted_by_price
    response = Unirest.get("http://localhost:3000/v1/products?sort_by_price=true")
    products = response.body
    pp products
  end

  def create_product
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
  end

  def show_one_product
    print "Enter a product id: "
    product_id = gets.chomp
    response = Unirest.get("http://localhost:3000/v1/products/#{product_id}")
    product = response.body
    pp product
  end

  def update_product
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
  end

  def delete_product
    print "Enter a product id: "
    product_id = gets.chomp
    response = Unirest.delete("http://localhost:3000/v1/products/#{product_id}")
    pp response.body
  end

  def order_product
    params = {}
    print "Product id: "
    params[:input_product_id] = gets.chomp
    print "Quantity: "
    params[:input_quantity] = gets.chomp
    response = Unirest.post("http://localhost:3000/v1/orders", parameters: params)
    order = response.body
    if order["errors"]
      puts "No good!"
      p order["errors"]
    else
      puts "All good!"
      pp order
    end
  end

  def show_all_orders
    response = Unirest.get("http://localhost:3000/v1/orders")
    orders = response.body
    pp orders
  end

  def signup
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
  end

  def login
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
    @jwt = response.body["jwt"]
    Unirest.default_header("Authorization", "Bearer #{@jwt}")
    pp response.body
  end

  def logout
    @jwt = ""
    Unirest.clear_default_headers()
    puts "Logged out successfully!"
  end

  def quit
    puts "Goodbye!"    
    exit
  end

  def run
    while true
      show_menu
      input_option = gets.chomp
      if input_option == "1"
        show_all_products
      elsif input_option == "1.1"
        show_all_products_search
      elsif input_option == "1.2"
        show_all_products_sorted_by_price
      elsif input_option == "2"
        create_product
      elsif input_option == "3"
        show_one_product
      elsif input_option == "4"
        update_product
      elsif input_option == "5"
        delete_product
      elsif input_option == "6"
        order_product
      elsif input_option == "7"
        show_all_orders
      elsif input_option == "signup"
        signup
      elsif input_option == "login"
        login
      elsif input_option == "logout"
        logout
      elsif input_option == "q"
        quit
      end
      puts "Press enter to continue"
      gets.chomp
    end    
  end
end

frontend = Frontend.new
frontend.run
