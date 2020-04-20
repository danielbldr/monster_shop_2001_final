require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :inventory }
    it { should validate_inclusion_of(:active?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @print_shop = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @tire = @print_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @bulk_discount1 = BulkDiscount.create!(minimum_items: 5, percentage_off: 5, description: "5% off 5 items or more", merchant_id: @bike_shop.id)
      @bulk_discount2 = BulkDiscount.create!(minimum_items: 10, percentage_off: 10, description: "10% off 10 items or more", merchant_id: @bike_shop.id)
      @bulk_discount3 = BulkDiscount.create!(minimum_items: 5, percentage_off: 5, description: "5% off 5 items or more", merchant_id: @print_shop.id)
      @bulk_discount4 = BulkDiscount.create!(minimum_items: 10, percentage_off: 10, description: "10% off 10 items or more", merchant_id: @print_shop.id)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      @user = User.create({name: "Regina",
                           street_address: "6667 Evil Ln",
                           city: "Storybrooke",
                           state: "ME",
                           zip_code: "00435",
                           email_address: "evilqueen@example.com",
                           password: "henry2004",
                           password_confirmation: "henry2004",
                           role: 0
                          })
      order = Order.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: @user.id)
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end

    it 'best_discount' do
      expect(@tire.best_discount(1)).to eq(nil)
      expect(@tire.best_discount(7)).to eq(@bulk_discount3)
      expect(@tire.best_discount(10)).to eq(@bulk_discount4)
    end
  end

  describe "class methods" do
    before(:each) do
      @user = User.create({name: "Regina",
                           street_address: "6667 Evil Ln",
                           city: "Storybrooke",
                           state: "ME",
                           zip_code: "00435",
                           email_address: "evilqueen@example.com",
                           password: "henry2004",
                           password_confirmation: "henry2004",
                           role: 0
                          })

      @order_1 = Order.create({name: "Bob", address: "22 dog st", city: "Fort Collins",
                                              state: "CO", zip: "80375", status: "Pending",
                                              user_id: @user.id})

      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @gloves = @meg.items.create(name: "Gloves", description: "It's a glove!!", price: 25, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 40)
      @locks = @meg.items.create(name: "Locks", description: "It's a chain!", price: 9, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 23)
      @leggings = @meg.items.create(name: "Leggings", description: "It's a legging!", price: 30, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 59)
      @helmet = @meg.items.create(name: "Helment", description: "It's a helmet!", price: 12, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 62)

      @item_order_1 =  @order_1.item_orders.create!({
                                                      item: @tire,
                                                      quantity: 4,
                                                      price: @tire.price
                                                      })
      @item_order_2 =  @order_1.item_orders.create!({
                                                      item: @chain,
                                                      quantity: 3,
                                                      price: @chain.price
                                                      })
      @item_order_4 =  @order_1.item_orders.create!({
                                                      item: @helmet,
                                                      quantity: 6,
                                                      price: @helmet.price
                                                      })
      @item_order_5 =  @order_1.item_orders.create!({
                                                      item: @locks,
                                                      quantity: 9,
                                                      price: @locks.price
                                                      })
      @item_order_6 =  @order_1.item_orders.create!({
                                                      item: @leggings,
                                                      quantity: 20,
                                                      price: @leggings.price
                                                      })

    end

    it 'most_popular_items' do
      expect(Item.most_popular_items).to eq(["Leggings", "Locks", "Helment", "Gatorskins", "Chain"])
    end

    it 'least_popular_items' do
      expect(Item.least_popular_items).to eq(["Gloves", "Chain", "Gatorskins", "Helment", "Locks"])
    end

  end
end
