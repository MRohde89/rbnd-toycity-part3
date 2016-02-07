class Customer

  attr_reader :name

  @@customers = []

  def initialize(options = {})
    @name = options[:name]
    add_to_customers
  end

# RETURNS CLASS
  def self.all
    @@customers
  end

# ADDS CUSTOMER TO @@customer CLASS
# IT WILL RAISE AN ERROR IF THE NAME ALREADY EXISTS IN THE CLASS
  def add_to_customers
    if self.class.get_customers.include? @name
      raise DuplicateCustomerError, "#{@name} already exists in the database"
    else @@customers << self
    end
  end

# RETURNS AN ARRAY OF ALL CUSTOMER NAMES, USED FOR THE add_to_customer METHOD
  def self.get_customers
    customer_array = []
    @@customers.each do |customer|
      customer_array << customer.name
    end
    return customer_array
  end

# FIND CUSTOMER BY NAME
  def self.find_by_name(find_name)
    hash_of_names = @@customers.select { |customer| customer.name == find_name}
    return hash_of_names[0] # because there will always be just one element inside
  end

# PURCHASE FROM A CUSTOMER, QUANTITY, SELL OR BUY, DISCOUNT CAN BE ADDED ADDTIONALLY
  def purchase(item, quantity = 1, sell_or_buy = 'sell', discount = 0)
    Transaction.new(self, item, quantity, sell_or_buy, discount)
  end

end
