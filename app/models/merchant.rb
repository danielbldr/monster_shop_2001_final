class Merchant <ApplicationRecord
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper

  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items
  has_many :users
  has_many :bulk_discounts

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip

  validates_inclusion_of :active?, :in => [true, false]

  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    # Merchant.find_by_sql("SELECT orders.city FROM orders INNER JOIN users ON users.id = orders.user_id WHERE 'active?' = true AND DISTINCT")
    item_orders.distinct.joins(:order).pluck(:city)
  end

  def pending_orders
    Order.joins(:items).where(items: {merchant_id: self.id}).where(orders: {status: "Pending"}).distinct
  end

  def deactivate_items
    if !active?
      items.each { |item| item.update(active?: false) }
    end
  end

  def activate_items
    if active?
      items.each { |item| item.update(active?: true) }
    end
  end

  def items_with_default_photo
    items.where(image: "https://www.intemposoftware.com/uploads/blog/Blog_inventory_control.jpg")
  end

  def unfulfilled_orders_stat
    number_of_pending_orders = pending_orders.count
    value_of_pending_orders = pending_orders.sum do |order|
                                order.item_orders.sum do |item_order|
                                  item_order.quantity * item_order.price
                                end
                              end
    "You have #{pluralize(number_of_pending_orders, "unfulfilled order")} worth #{number_to_currency(value_of_pending_orders)}"
  end

end
