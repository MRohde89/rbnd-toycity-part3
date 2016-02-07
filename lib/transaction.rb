require 'etc' # Used for the Username, that has entered the transaction

class Transaction

  attr_reader :customer, :product, :id, :quantity, :sell_or_buy, :timestamp, :username

  @@transactions = []
  @@id = 1

  def initialize(customer_hash, product_hash, quantity = 1, sell_or_buy = 'sell', discount = 0, timestamp = Time.now)
    @customer = customer_hash
    @product = product_hash
    @id = @@id
    @quantity = quantity * (sell_or_buy == 'sell' ? -1:1)
    @sell_or_buy = sell_or_buy
    @product.price = @product.price * (1-discount)
    @timestamp = timestamp
    @username = Etc.getlogin

    if @sell_or_buy == 'sell'
      # first it needs to be checked if there is enough in inventory, before we add it to the transaction
      # an error will raise if there is not enough in stock
      add_to_transactions
      change_stock
      change_wallet_amount
    else
      # if we buy something, it needs to be checked if there is enough amount in our wallet.
      # an error will raise if there is not enough in the wallet
      change_wallet_amount
      change_stock
      add_to_transactions
    end

    end

  def remove_from_stock
    # decreasing the stock in the Product Class
    grab_hash = Product.find_by_title(@product.title)
    Product.all.each do |product_hash|
        product_hash.stock -= @quantity if product_hash == grab_hash
    end
  end

  def self.all
    @@transactions
  end

  def add_to_transactions
    if @product.in_stock?(quantity)
      in_stock_add_to_transactions
    else
    raise OutOfStockError, "#{@product.title} is currently out of stock"
    end
  end

  def self.find(index)
    @@transactions[index-1]
  end

  def change_stock
    grab_hash = Product.find_by_title(@product.title)
    Product.all.each do |product_hash|
        product_hash.stock += @quantity if product_hash == grab_hash
    end

  end

  def in_stock_add_to_transactions
    @@transactions << self
    @@id += 1
  end

  def change_wallet_amount
    Wallet.change_money(@quantity * @product.price)
  end

  def self.save_to_file(filename = "transactions_until_#{Time.now}.txt")
    $transaction_file = File.new(filename, "w+")
    make_header
    puts_data
    $transaction_file.close
  end

  def self.make_header
    $transaction_file.puts           " _______                             _   _                "
    $transaction_file.puts           "|__   __|                           | | (_)                "
    $transaction_file.puts           "  | |_ __ __ _ _ __  ___  __ _  ___| |_ _  ___  _ __  ___ "
    $transaction_file.puts           "  | | '__/ _` | '_ \\/ __|/ _` |/ __| __| |/ _ \\| '_ \\/ __|"
    $transaction_file.puts           "  | | | | (_| | | | \\__ \\ (_| | (__| |_| | (_) | | | \\__ \\"
    $transaction_file.puts           "  |_|_|  \\__,_|_| |_|___/\\__,_|\\___|\\__|_|\\___/|_| |_|___/"
    $transaction_file.puts
  end

  def self.puts_data
    @@transactions.each do |item|
      $transaction_file.puts "ID: #{item.id}"
      $transaction_file.puts "Customer Name: #{item.customer.name}"
      $transaction_file.puts "Product: #{item.product.title}"
      $transaction_file.puts "Quantity: #{item.quantity}"
      $transaction_file.puts "Timestamp: #{item.timestamp}"
      $transaction_file.puts "By User: #{item.username}"
      $transaction_file.puts "------ next transaction ------"
      $transaction_file.puts "------------------------------"
    end
  end



end
