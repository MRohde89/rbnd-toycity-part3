class Product

  attr_accessor :title, :item_array, :stock, :price

  @@products = []

  def initialize(options={})
    @title = options[:title]
    @price = options[:price]
    @stock = options[:stock]
    add_to_products
  end

# RETURNS CLASS
  def self.all
    return @@products
  end

# RETURNS AN ARRAY OUT OF ALL TITLES -> USED FOR THE add_to_products METHOD
  def self.get_items
    item_array = []
    @@products.each do |item|
      item_array << item.title
    end
    return item_array
  end

# ADDS PRODUCT TO @@products, UNLESS THE TITLES ALREADY EXISTS IN THE @@products ARRAY
  def add_to_products
    if self.class.get_items.include? @title
      raise DuplicateProductError, "#{@title} already exists in the database"
    else @@products << self
    end
  end


# RETURNS ALL ELEMENTS OF THE SPECIFIC ARRAY
  def self.find_by_title(find_toy)
    hash_of_toys = @@products.select { |toy| toy.title == find_toy}
    return hash_of_toys[0] # because there will always be just one element inside
  end

# TRUE/FALSE METHOD, RETURNS TRUE OR FALSE, IF THE ITEM IS STILL IN STOCK
# OPTIONAL FIELD IN ORDER TO SEE IF A GIVEN QUANTITY CAN BE REMOVED FROM THE STOCK
# IN CASE OF QUANTITY, THE STOCK NEEDS CAN BE DECREASED UP TO 0, THAT'S WHY maybe_removed IS >= THEN 0
  def in_stock?(maybe_removed = -1)
    self.stock + maybe_removed >= 0 ? true : false
  end

# RETURNS THE ALL ITEMS WHICH ARE IN STOCK
  def self.in_stock
    return having_toys_in_stock = @@products.select {|toy| toy.stock != 0}
  end

end
