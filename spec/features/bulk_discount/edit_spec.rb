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

  it 'I can edit my bulk discounts' do
    click_link "View Bulk Discounts"
    within("#discount-#{@bulk_discount1.id}") do
      click_link @bulk_discount1.description
    end

    click_button "Edit This Discount"
    expect(current_path).to eq("/bulk_discounts/#{@bulk_discount1.id}/edit")

    fill_in :description, with: "10% off 10 items or more"
    fill_in :percentage_off, with: 10
    fill_in :minimum_items, with: 10
    click_button "Update This Discount"
    @bulk_discount1.reload

    expect(current_path).to eq("/bulk_discounts/#{@bulk_discount1.id}")
    expect(page).to have_content("Your discount has been updated")

    expect(page).to have_content("Percentage Off: #{@bulk_discount1.percentage_off}")
    expect(page).to have_content("Minimum Items: #{@bulk_discount1.minimum_items}")
    expect(page).to have_content(@bulk_discount1.description)

    expect(page).to_not have_content("5% off 5 items or more")
    expect(page).to_not have_content("Percentage Off: 5%")
    expect(page).to_not have_content("Minimum Items: 5")
  end

  it "I cannot update a discount with bad info" do
    click_link "View Bulk Discounts"
    within("#discount-#{@bulk_discount1.id}") do
      click_link @bulk_discount1.description
    end

    click_button "Edit This Discount"

    fill_in :description, with: ""
    fill_in :percentage_off, with: "This"
    fill_in :minimum_items, with: 10
    click_button "Update This Discount"
    expect(current_path).to eq("/bulk_discounts/#{@bulk_discount1.id}/edit")
    expect(page).to have_content("Description can't be blank and Percentage off must be a number between 1 and 100")
  end
end
