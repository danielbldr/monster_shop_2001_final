class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def subtotal(item)
    item_quantity = @contents[item.id.to_s]
    if !item_quantity.nil? && item.best_discount(item_quantity)
      (item.price * @contents[item.id.to_s]) * ((100.00 - item.best_discount(item_quantity)[:percentage_off])/100)
    else
      item.price * @contents[item.id.to_s]
    end
  end

  def total
    @contents.sum do |item_id,quantity|
      subtotal(Item.find(item_id))
    end
  end

end
