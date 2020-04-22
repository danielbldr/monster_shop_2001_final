require 'rails_helper'

RSpec.describe 'As a user when I visit my cart' do
  before(:each) do
    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @bulk_discount1 = BulkDiscount.create!(minimum_items: 5, percentage_off: 5, description: "5% off 5 items or more", merchant_id: @mike.id)
    @bulk_discount2 = BulkDiscount.create!(minimum_items: 10, percentage_off: 10, description: "10% off 10 items or more", merchant_id: @mike.id)
    @bulk_discount3 = BulkDiscount.create!(minimum_items: 5, percentage_off: 5, description: "5% off 5 items or more", merchant_id: @meg.id)
    @bulk_discount4 = BulkDiscount.create!(minimum_items: 10, percentage_off: 10, description: "10% off 10 items or more", merchant_id: @meg.id)

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    visit "/items/#{@paper.id}"
    click_on "Add To Cart"
    visit "/items/#{@tire.id}"
    click_on "Add To Cart"
    visit "/items/#{@pencil.id}"
    click_on "Add To Cart"
  end

  it "I can see a bulk discount automatically applied on qualified purchases" do
    visit '/cart'

    within "#cart-item-#{@paper.id}" do
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
      expect(page).to have_content(6)
    end
  end
end
