require 'rails_helper'

RSpec.describe 'As a merchant employee', type: :feature do
  before(:each) do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @bulk_discount1 = BulkDiscount.create(minimum_items: 5, percentage_off: 5, description: "5% off 5 items or more", merchant_id: @bike_shop.id)
    User.create({name: "Regina",
      street_address: "6667 Evil Ln",
      city: "Storybrooke",
      state: "ME",
      zip_code: "00435",
      email_address: "evilqueen@example.com",
      password: "henry2004",
      password_confirmation: "henry2004",
      role: 1,
      merchant_id: @bike_shop.id
      })
      visit '/'

      click_link 'Log in'

      fill_in :email_address, with: 'evilqueen@example.com'
      fill_in :password, with: 'henry2004'
      click_button 'Log in'
  end

  it "can add a new discount" do
    click_link "View Bulk Discounts"
    click_link "Add New Discount"

    fill_in :description, with: "15% off 15 items or more"
    fill_in :minimum_items, with: 15
    fill_in :percentage_off, with: 15
    click_button "Submit"

    expect(page).to have_content("You successfully added the 15% off 15 items or more discount")
    expect(current_path).to eq("/bulk_discounts")

    within("#discount-#{@bulk_discount1.id}") do
      expect(page).to have_content(@bulk_discount1.minimum_items)
      expect(page).to have_content(@bulk_discount1.percentage_off)
      expect(page).to have_content(@bulk_discount1.description)
    end

    bulk_discount2 = BulkDiscount.last

    within("#discount-#{bulk_discount2.id}") do
      expect(page).to have_content("15% off 15 items or more")
      expect(page).to have_content(bulk_discount2.percentage_off)
      expect(page).to have_content(bulk_discount2.description)
    end
  end

  it "I cannot add a new discount with bad information" do
    click_link "View Bulk Discounts"
    click_link "Add New Discount"

    fill_in :description, with: ""
    fill_in :minimum_items, with: 15
    fill_in :percentage_off, with: "ten"
    click_button "Submit"

    expect(page).to have_content("Description can't be blank and Percentage off must be a number between 1 and 100")
    expect(current_path).to eq("/bulk_discounts/new")
  end
end
