require 'etc' # Used for the Username, that has entered the transaction

class Transaction

  attr_reader :customer, :product, :id, :quantity, :sell_or_buy, :timestamp, :username

  @@transactions = []
  @@id = 1

# NEEDS TO HAVE A CUSTOMER_HASH DATA, A PRODUCT_HASH DATA
# ADDITIONAL PROVIDED INFORMATION CAN BE THE QUANTITY, IF IT IS SOLD OR BOUGHT, IF THERE IS A DISCOUNT IN
# AS WELL AS A TIMESTAMP
  def initialize(customer_hash, product_hash, quantity = 1, sell_or_buy = 'sell', discount = 0, timestamp = Time.now)
    @customer = customer_hash
    @product = product_hash
    @id = @@id
    # quantity will be multiplied by 1/-1 according sell or buy
    @quantity = quantity * (sell_or_buy == 'sell' ? -1:1)
    @sell_or_buy = sell_or_buy
    # discount will be taken into consideration
    @product.price = @product.price * (1-discount)
    @timestamp = timestamp
    # to avoid fraud booking the user login will be saved
    @username = Etc.getlogin
    # create new Wallet if there is no Class Wallet already initializied
    Wallet.new unless Object.const_defined?("Wallet")
    # differnt process for sold or bought products. Because of the different Errors
    if @sell_or_buy == 'sell'
      # first it needs to be checked if there is enough in inventory, before we add it to the transaction
      # an error will raise if there is not enough in stock and no transaction will be created
      add_to_transactions # this method includes also a check for stock availability
      change_stock
      change_wallet_amount
    else
      # if we buy something, it needs to be checked if there is enough amount in our wallet.
      # an error will raise if there is not enough in the wallet and no transaction will be created
      change_wallet_amount
      change_stock
      add_to_transactions
    end

    end

# RETURNS CLASS
  def self.all
    @@transactions
  end

# ADDS ITEM TO TRANSACTION ALSO CALLS THE IN STOCK METHOD TO SEE IF IT CAN BE ADDED
# IF THERE ARE NOT ENOUGH ITEMS IN THE INVENTORY, THE METHOD WILL RAISE AN ERROR
  def add_to_transactions
    if @product.in_stock?(quantity)
      in_stock_add_to_transactions
    else
    raise OutOfStockError, "#{@product.title} is currently out of stock"
    end
  end

# FIND TRANSACTION BY ID
  def self.find(index)
    # since ID is always the index + 1, the searched transaction element is index-1
    @@transactions[index-1]
  end

# CHANGE STOCK WILL CHANGE THE STOCK ONCE EVERYTHING ELSE IS APPROVED (ENOUGH MONEY, ENOUGH STOCK)
  def change_stock
    grab_hash = Product.find_by_title(@product.title)
    Product.all.each do |product_hash|
        product_hash.stock += @quantity if product_hash == grab_hash
    end
  end

# USED FOR add_to_transactions method
# INCREASES ID BY 1 AND ADDED ELEMENT TO TRANSACTIONS
  def in_stock_add_to_transactions
    @@transactions << self
    @@id += 1
  end

# CHANGES THE AMOUNT OF THE WALLET BY QUANTITY * PRICE
# (BUY OR SELL WILL DECIDE IF IT IS NEGATIVE OR POSITIVE)
  def change_wallet_amount
    Wallet.change_cash(@quantity * @product.price)
  end

# SAVE TRANSACTIONS TO FILE
  def self.save_to_file(filename = "transactions_until_#{Time.now}.txt")
    $transaction_file = File.new(filename, "w+")
    make_header
    puts_data
    $transaction_file.close
  end

# HEADER METHOD FOR FILE SAVING
  def self.make_header
    $transaction_file.puts           " _______                             _   _                "
    $transaction_file.puts           "|__   __|                           | | (_)                "
    $transaction_file.puts           "   | |_ __ __ _ _ __  ___  __ _  ___| |_ _  ___  _ __  ___ "
    $transaction_file.puts           "   | | '__/ _` | '_ \\/ __|/ _` |/ __| __| |/ _ \\| '_ \\/ __|"
    $transaction_file.puts           "   | | | | (_| | | | \\__ \\ (_| | (__| |_| | (_) | | | \\__ \\"
    $transaction_file.puts           "   |_|_|  \\__,_|_| |_|___/\\__,_|\\___|\\__|_|\\___/|_| |_|___/"
    $transaction_file.puts
  end

# DATA METHOD FOR FILE SAVING
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
