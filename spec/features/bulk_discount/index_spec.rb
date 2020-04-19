require 'rails_helper'

RSpec.describe 'As a merchant employee', type: :feature do
  it 'I can view my bulk discounts' do
    bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    bulk_discount1 = BulkDiscount.create(minimum_items: 5, percentage_off: 5, description: "5% off 5 items or more", merchant_id: bike_shop.id)
    User.create({name: "Regina",
                 street_address: "6667 Evil Ln",
                 city: "Storybrooke",
                 state: "ME",
                 zip_code: "00435",
                 email_address: "evilqueen@example.com",
                 password: "henry2004",
                 password_confirmation: "henry2004",
                 role: 1,
                 merchant_id: bike_shop.id
                })
    visit '/'

    click_link 'Log in'

    fill_in :email_address, with: 'evilqueen@example.com'
    fill_in :password, with: 'henry2004'
    click_button 'Log in'

    click_link "View Bulk Discounts"
    expect(current_path).to eq("/bulk_discounts")
    
    expect(page).to have_content("#{bike_shop.name}'s Bulk Discounts")

    within("#discount-#{bulk_discount1.id}") do
      expect(page).to have_content(bulk_discount1.minimum_items)
      expect(page).to have_content(bulk_discount1.percentage_off)
      expect(page).to have_content(bulk_discount1.description)
    end
  end
end
