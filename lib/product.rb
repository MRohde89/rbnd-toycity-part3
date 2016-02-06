class Product

  attr_accessor :title, :item_array, :stock, :price

  @@products = []

  def initialize(options={})
    @title = options[:title]
    @price = options[:price]
    @stock = options[:stock]
    add_to_products
  end

  def self.all
    return @@products
  end


  def self.get_items
    item_array = []
    @@products.each do |item|
      item_array << item.title
    end
    return item_array
  end

  def add_to_products
    if self.class.get_items.include? @title
      raise DuplicateProductError, "#{@title} already exists in the database"
    else @@products << self
    end
  end

  def self.find_by_title(find_toy)
    hash_of_toys = @@products.select { |toy| toy.title == find_toy}
    return hash_of_toys[0] # because there will always be just one element inside
  end

  def in_stock?(maybe_removed = 1)
    self.stock - maybe_removed >= 0 ? true : false
  end

  def self.in_stock
    return having_toys_in_stock = @@products.select {|toy| toy.stock != 0}
    #return having_toys_in_stock.map { |not_in_stock_toy| not_in_stock_toy.title}
  end

end
