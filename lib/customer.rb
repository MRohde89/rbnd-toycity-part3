class Customer

  attr_reader :name

  @@customers = []

  def initialize(options = {})
    @name = options[:name]
    add_to_customers
  end


  def self.all
    @@customers
  end

  def add_to_customers
    if self.class.get_customers.include? @name
      raise DuplicateCustomerError, "#{@name} already exists in the database"
    else @@customers << self
    end
  end

  def self.get_customers
    customer_array = []
    @@customers.each do |customer|
      customer_array << customer.name
    end
    return customer_array
  end

  def self.find_by_name(find_name)
    hash_of_names = @@customers.select { |customer| customer.name == find_name}
    return hash_of_names[0] # because there will always be just one element inside
  end

end
