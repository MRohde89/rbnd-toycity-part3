class Transaction

  attr_reader :customer, :product, :id

  @@id = 1

  def initialize(customer_hash, product_hash)
    @customer = customer_hash

    # remove from stock before adding the element to the transaction
    remove_from_stock
    @product = product_hash
    @id = @@id
    @@id += 1

  end

  def remove_from_stock
    # decreasing the stock in the Product Class
    grab_hash = Product.find_by_title(@product.title)
    Product.all.each do |product_hash|
        product_hash.stock -= 1 if product_hash == grab_hash
    end

  end



end
