require 'rails_helper'

RSpec.describe "As a merchant employee I see a to do list" do
  before(:each) do
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @pull_toy = @meg.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, inventory: 32)
    @dog_bone = @meg.items.create(name: "Dog Bone", description: "They'll love it!", price: 20, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)

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

    visit '/'

    click_on 'Log in'
    fill_in :email_address, with: 'evilqueen@example.com'
    fill_in :password, with: 'henry2004'
    click_button 'Log in'
  end
  it "will tell me which items do not have a picutre of their own" do
    within(".to-do-list") do
      expect(page).to have_content("Items Needing a Photo")
      expect(page).to have_link(@pull_toy.name)
      expect(page).to_not have_link(@dog_bone.name)
      click_link(@pull_toy.name)
    end

    expect(current_path).to eq("/merchant/items/#{@pull_toy.id}/edit")
    fill_in :image, with: "https://assets.petco.com/petco/image/upload/f_auto,q_auto,t_ProductDetail-large/629081-center-1"
    click_button "Update Item"

    visit "/merchant"

    within(".to-do-list") do
      expect(page).to have_content("Items Needing a Photo")
      expect(page).to_not have_link(@pull_toy.name)
      expect(page).to_not have_link(@dog_bone.name)
    end
  end
end
