require 'rails_helper'

RSpec.describe "Merchant Items Index Page" do
  describe "When I visit the merchant items page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @regina = User.create({name: "Regina",
                           street_address: "6667 Evil Ln",
                           city: "Storybrooke",
                           state: "ME",
                           zip_code: "00435",
                           email_address: "evilqueen@example.com",
                           password: "henry2004",
                           password_confirmation: "henry2004",
                           role: 1,
                           merchant_id: @meg.id
                          })

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @shifter = @meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)
      @order_1 = Order.create({name: "Bob", address: "22 dog st", city: "Fort Collins",
                          state: "CO", zip: "80375", status: "Pending", user_id: @regina.id})
      @item_order_1 =  @order_1.item_orders.create!({
                                                      item: @tire,
                                                      quantity: 3,
                                                      price: @tire.price
                                                      })
      @item_order_2 =  @order_1.item_orders.create!({
                                                      item: @shifter,
                                                      quantity: 5,
                                                      price: @shifter.price
                                                      })

      visit '/'

      click_link 'Log in'

      fill_in :email_address, with: 'evilqueen@example.com'
      fill_in :password, with: 'henry2004'
      click_button 'Log in'
    end

    it 'shows me a list of that merchants items' do
      visit "merchants/#{@meg.id}/items"

      within "#merch-item-#{@tire.id}" do
        expect(page).to have_content(@tire.name)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_css("img[src*='#{@tire.image}']")
        expect(page).to have_content("Active")
        expect(page).to_not have_content(@tire.description)
        expect(page).to have_content("Inventory: #{@tire.inventory}")
      end

      within "#merch-item-#{@chain.id}" do
        expect(page).to have_content(@chain.name)
        expect(page).to have_content("Price: $#{@chain.price}")
        expect(page).to have_css("img[src*='#{@chain.image}']")
        expect(page).to have_content("Active")
        expect(page).to_not have_content(@chain.description)
        expect(page).to have_content("Inventory: #{@chain.inventory}")
      end

      within "#merch-item-#{@shifter.id}" do
        expect(page).to have_content(@shifter.name)
        expect(page).to have_content("Price: $#{@shifter.price}")
        expect(page).to have_css("img[src*='#{@shifter.image}']")
        expect(page).to have_content("Inactive")
        expect(page).to_not have_content(@shifter.description)
        expect(page).to have_content("Inventory: #{@shifter.inventory}")
      end
    end

    it "can deactivate an item from their items page" do
      visit "/merchant"
      click_link 'View My Items'
      expect(current_path).to eq("/merchant/items")
      within "#merch-item-#{@tire.id}" do
        expect(page).to have_content(@tire.name)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_css("img[src*='#{@tire.image}']")
        expect(page).to have_content("Active")
        expect(page).to_not have_content(@tire.description)
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        click_link("Deactivate")
        expect(current_path).to eq("/merchant/items")
        expect(page).to have_content("Inactive")
      end

      expect(page).to have_content("#{@tire.name} is no longer for sale")
    end

    it "can deactivate an item from their items page" do
      visit "/merchant"
      click_link 'View My Items'
      expect(current_path).to eq("/merchant/items")
      within "#merch-item-#{@shifter.id}" do
        expect(page).to have_content(@shifter.name)
        expect(page).to have_content("Price: $#{@shifter.price}")
        expect(page).to have_css("img[src*='#{@shifter.image}']")
        expect(page).to have_content("Inactive")
        expect(page).to_not have_content(@shifter.description)
        expect(page).to have_content("Inventory: #{@shifter.inventory}")
        click_link("Activate")
        expect(current_path).to eq("/merchant/items")
        expect(page).to have_content("Active")
      end

      expect(page).to have_content("#{@shifter.name} is now available for sale")
    end

    it "can delete an item that has never been ordered" do
      visit "/merchant/items"
      within "#merch-item-#{@shifter.id}" do
        expect(page).to_not have_link("Delete")
      end
      within "#merch-item-#{@chain.id}" do
        click_link("Delete")
      end
      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content("#{@chain.name} has been deleted")
      expect(page).to_not have_content(@chain.description)
    end

    it 'can add a new item' do
      visit "/merchant/items"
      click_link "Add New Item"
      expect(current_path).to eq("/merchant/items/new")

      fill_in :name, with: "Helmet"
      fill_in :price, with: 20
      fill_in :description, with: "Protect your head"
      fill_in :image, with: "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/HNNN2?wid=1144&hei=1144&fmt=jpeg&qlt=95&op_usm=0.5%2C0.5&.v=1570147746237"
      fill_in :inventory, with: 25
      click_button "Create Item"

      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content("Your item 'Helmet' has been saved")
      expect(page).to have_css("img[src*='https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/HNNN2?wid=1144&hei=1144&fmt=jpeg&qlt=95&op_usm=0.5%2C0.5&.v=1570147746237']")
      expect(page).to have_content("Helmet")
      expect(page).to have_content("Price: $20.00")
      expect(page).to have_content("Inventory: 25")
      expect(page).to have_content("Active")
      expect(page).to have_link("Deactivate")
      expect(page).to have_link("Delete")
    end

    it 'can add a new item without image' do
      visit "/merchant/items"
      click_link "Add New Item"
      expect(current_path).to eq("/merchant/items/new")

      fill_in :name, with: "Helmet"
      fill_in :price, with: 20
      fill_in :description, with: "Protect your head"
      fill_in :inventory, with: 25
      click_button "Create Item"

      new_item = Item.last

      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content("Your item 'Helmet' has been saved")
      expect(page).to have_content(new_item.name)
      expect(page).to have_css("img[src*='https://www.intemposoftware.com/uploads/blog/Blog_inventory_control.jpg']")
      expect(page).to have_content(new_item.price)
      expect(page).to have_content(new_item.inventory)
      expect(page).to have_content("Active")
      expect(page).to have_link("Deactivate")
      expect(page).to have_link("Delete")
    end

    it 'cannot add incorrect or missing data and will repopulate form with previous data' do
      visit "/merchant/items"
      click_link "Add New Item"
      expect(current_path).to eq("/merchant/items/new")


      fill_in :price, with: -20
      click_button "Create Item"

      expect(page).to have_content("Name can't be blank, Description can't be blank, Inventory can't be blank, Inventory is not a number, and Price must be greater than 0")
      expect(page).to have_selector("input[value='-$20.00']")
      expect(page).to have_button("Create Item")
    end
  end
end

# User Story 46, Merchant cannot add an item if details are bad/missing
#
# As a merchant employee
# When I try to add a new item
# If any of my data is incorrect or missing (except image)
# Then I am returned to the form
# I see one or more flash messages indicating each error I caused
# All fields are re-populated with my previous data
