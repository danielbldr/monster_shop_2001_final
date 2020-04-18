require 'rails_helper'

describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should have_many :items}
    it {should have_many :users}
    it {should have_many :bulk_discounts}
  end

  describe 'instance methods' do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    end

    it 'no_orders' do
      expect(@meg.no_orders?).to eq(true)

      user = User.create!({name: "Bob", street_address: "22 dog st", city: "Fort Collins",
                           state: "CO", zip_code: "80375", email_address: "bob@example.com",
                           password: "password1", password_confirmation: "password1", role: 0
                          })
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: user.id)
      item_order_1 = order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.no_orders?).to eq(false)
    end

    it 'item_count' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 30, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.item_count).to eq(2)
    end

    it 'average_item_price' do
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)

      expect(@meg.average_item_price).to eq(70)
    end

    it 'distinct_cities' do
      user = User.create!({name: "Bob", street_address: "22 dog st", city: "Fort Collins",
                           state: "CO", zip_code: "80375", email_address: "bob@example.com",
                           password: "password1", password_confirmation: "password1", role: 0
                          })
      # bob = User.create!({name: "Bob", street_address: "22 dog st", city: "Boulder",
      #                      state: "CO", zip_code: "80375", email_address: "bob2@example.com",
      #                      password: "password1", password_confirmation: "password1", role: 0,
      #                     active?: false
      #                     })
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: user.id)
      order_2 = Order.create!(name: 'Brian', address: '123 Brian Ave', city: 'Denver', state: 'CO', zip: 17033, user_id: user.id)
      order_3 = Order.create!(name: 'Dao', address: '123 Mike Ave', city: 'Denver', state: 'CO', zip: 17033, user_id: user.id)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      order_2.item_orders.create!(item: chain, price: chain.price, quantity: 2)
      order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      # bob_order_1 = Order.create!(name: 'Dao', address: '123 Mike Ave', city: 'Colorado Springs', state: 'CO', zip: 17033, user_id: bob.id)
      # bob_order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)


      expect(@meg.distinct_cities.sort).to eq(["Denver","Hershey"])
    end

    it 'deactivate_items' do
      @meg.update(active?: false)
      @meg.deactivate_items

      expect(@tire.active?).to be_falsey
    end

    it 'activate_items' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203, active?:false)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", active?: false, inventory: 12)

      meg.update(active?: true)
      meg.activate_items

      expect(tire.active?).to be_truthy
    end

    it 'pending_orders' do
      user = User.create!({name: "Bob", street_address: "22 dog st", city: "Fort Collins",
                           state: "CO", zip_code: "80375", email_address: "bob@example.com",
                           password: "password1", password_confirmation: "password1", role: 0
                          })
      chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 40, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 22)
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: user.id, status: "Pending")
      order_2 = Order.create!(name: 'Brian', address: '123 Brian Ave', city: 'Denver', state: 'CO', zip: 17033, user_id: user.id, status:"Packaged")
      order_3 = Order.create!(name: 'Dao', address: '123 Mike Ave', city: 'Denver', state: 'CO', zip: 17033, user_id: user.id, status: "Pending")
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      order_2.item_orders.create!(item: chain, price: chain.price, quantity: 2)
      order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.pending_orders).to eq([order_1, order_3])
    end
  end
end
