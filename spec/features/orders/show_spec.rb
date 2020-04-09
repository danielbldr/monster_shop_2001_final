RSpec.describe("Orders Show Page") do

    before(:each) do
      user = User.create({name: "Bob", street_address: "22 dog st", city: "Fort Collins",
                           state: "CO", zip_code: "80375", email_address: "bob@example.com",
                           password: "password1", password_confirmation: "password1", role: 0
                          })
      visit '/login'
      fill_in :email_address, with: "bob@example.com"
      fill_in :password, with: "password1"
      within ("#login-form") do
        click_on "Log in"
      end
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

       @order_1 = Order.create({name: "Bob", address: "22 dog st", city: "Fort Collins",
                           state: "CO", zip: "80375", status: "pending"})
       @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
       @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
       @chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

       @order_1.item_orders.create!({
         item: @tire,
         quantity: 3,
         price: @tire.price
         })
       end

    it "can see link if there are orders" do
      visit '/user/profile'
      click_on "My Orders"
      expect(current_path).to eq("/user/profile/orders")
    end

    it "can see order info on my orders page" do
      visit "/user/profile/orders"
      within("##{@order_1.id}") do
        expect(page).to have_link("#{@order_1.id}")
        expect(page).to have_content("Date ordered: #{@order_1.created_at}")
        expect(page).to have_content("Date updated: #{@order_1.updated_at}")
        expect(page).to have_content("Current Status: #{@order_1.status}")
        expect(page).to have_content("Number of Items: #{@order_1.items.count}")
        expect(page).to have_content("Grand Total: #{@order_1.grandtotal}")
      end
    end

end



# As a registered user
# When I visit my Profile Orders page, "/profile/orders"
# I see every order I've made, which includes the following information:
# - the ID of the order, which is a link to the order show page
# - the date the order was made
# - the date the order was last updated
# - the current status of the order
# - the total quantity of items in the order
# - the grand total of all items for that order
