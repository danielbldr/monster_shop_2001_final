# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Merchant.destroy_all
Item.destroy_all
User.destroy_all
Order.destroy_all
ItemOrder.destroy_all

#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "https://images-na.ssl-images-amazon.com/images/I/71L30-Xfs9L._AC_SX425_.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

#users
bob = User.create({name: "Bob",
                   street_address: "22 dog st",
                   city: "Fort Collins",
                   state: "CO",
                   zip_code: "80375",
                   email_address: "user@example.com",
                   password: "password_regular",
                   password_confirmation: "password_regular",
                   role: 0
                    })
regina = User.create({name: "Regina",
                       street_address: "6667 Evil Ln",
                       city: "Storybrooke",
                       state: "ME",
                       zip_code: "00435",
                       email_address: "merchant1@example.com",
                       password: "password_merchant",
                       password_confirmation: "password_merchant",
                       role: 1,
                       merchant_id: bike_shop.id
                      })

regina = User.create({name: "Elmo",
                       street_address: "123 Sesame St",
                       city: "New York City",
                       state: "NY",
                       zip_code: "10001",
                       email_address: "merchant2@example.com",
                       password: "password_merchant",
                       password_confirmation: "password_merchant",
                       role: 1,
                       merchant_id: dog_shop.id
                      })

bert = User.create({name: "Bert",
                      street_address: "123 Sesame St.",
                      city: "New York City",
                      state: "NY",
                      zip_code: "10001",
                      email_address: "admin@example.com",
                      password: "password_admin",
                      password_confirmation: "password_admin",
                      role: 2
                     })

#orders
order_1 = Order.create(name: 'Regina', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: "Pending", user_id: regina.id)
order_2 = Order.create(name: 'Bob', address: '123 Zanti St', city: 'Denver', state: 'CO', zip: 80204, status: "Pending", user_id: bob.id)
order_3 = Order.create(name: 'Bob', address: '123 Zanti St', city: 'Denver', state: 'CO', zip: 80204, status: "Cancelled", user_id: bob.id)

order_1.item_orders.create(item: tire, price: tire.price, quantity: 2)
order_1.item_orders.create(item: pull_toy, price: pull_toy.price, quantity: 3)
order_2.item_orders.create(item: pull_toy, price: pull_toy.price, quantity: 3)
order_3.item_orders.create(item: dog_bone, price: dog_bone.price, quantity: 1)

#merchant_discounts
BulkDiscount.create(minimum_items: 5, percentage_off: 5, description: "5% off 5 items or more", merchant_id: bike_shop.id)
BulkDiscount.create(minimum_items: 10, percentage_off: 10, description: "10% off 10 items or more", merchant_id: bike_shop.id)
BulkDiscount.create(minimum_items: 10, percentage_off: 10, description: "10% off 10 items or more", merchant_id: dog_shop.id)
