class Product

  attr_reader :title, :item_array


  @@products = []

  def initialize(options={})
    @title = options[:title]
    add_to_products
  end

  def self.all
    @@products
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



end
