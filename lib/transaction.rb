class Transaction

  attr_reader :customer, :product, :id

  @@transactions = []
  @@id = 1

  def initialize(customer_hash, product_hash)
    @customer = customer_hash
    @product = product_hash
    @id = @@id
    @@id += 1
    remove_from_stock
    add_to_transactions

  end

  def remove_from_stock
    # decreasing the stock in the Product Class
    grab_hash = Product.find_by_title(@product.title)
    Product.all.each do |product_hash|
        product_hash.stock -= 1 if product_hash == grab_hash
    end
  end

  def self.all
    @@transactions
  end

  def add_to_transactions
    if @product.in_stock?
    raise OutOfStockError, "#{@product.title} is currently out of stock"
    else
    @@transactions << self
  end
  end

  def self.find(index)
    @@transactions[index-1]
  end

end
