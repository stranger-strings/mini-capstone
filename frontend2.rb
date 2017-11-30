require "unirest"
require "pp"

class Frontend
  def initialize
    @jwt = ""
    @menu_options = [
      {value: "1", prompt: "Show all products", method: -> do show_all_products end},
      {value: "1.1", prompt: "Show all products that match search terms", method: -> do show_all_products_search end},
      {value: "1.2", prompt: "Show all products sorted by price", method: -> do show_all_products_sorted_by_price end},
      {value: "2", prompt: "Create a product", method: -> do create_product end},
      {value: "3", prompt: "Show one product", method: -> do show_one_product end},
      {value: "4", prompt: "Update a product", method: -> do update_product end},
      {value: "5", prompt: "Delete a product", method: -> do delete_product end},
      {value: "6", prompt: "Order a product", method: -> do order_product end},
      {value: "7", prompt: "View all orders", method: -> do show_all_orders end},
      {value: "signup", prompt: "Sign up (create a user)", method: -> do signup end},
      {value: "login", prompt: "Log in (create a jwt)", method: -> do login end},
      {value: "logout", prompt: "Log out (destroy the jwt)", method: -> do logout end},
      {value: "q", prompt: "Quit", method: -> do quit end}
    ]
  end

  def find_menu_option(input_value)
    @menu_options.each do |menu_option|
      if menu_option[:value] == input_value
        return menu_option
      end
    end
    return nil
  end

  def show_menu
    system "clear"
    puts "Choose an option:"
    @menu_options.each do |menu_option|
      puts "[#{menu_option[:value]}] #{menu_option[:prompt]}"
    end
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
      menu_option = find_menu_option(input_option)
      if menu_option
        menu_option[:method].call
      else
        puts "Unknown option."        
      end
      puts "Press enter to continue"
      gets.chomp
    end    
  end
end

frontend = Frontend.new
frontend.run
