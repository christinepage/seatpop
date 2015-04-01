# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

PartyStatus.create!(name:  "waiting")
PartyStatus.create!(name:  "seated")
PartyStatus.create!(name:  "exited")

current_user = User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)

other_user = User.create!(name:  "Other User",
             email: "example1@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     false,
             activated: true,
             activated_at: Time.zone.now)
             
delfina = Restaurant.create!(name:  "Delfina", picture: Rails.root.join("public/uploads/restaurant/picture/1/8.jpg").open).users.append(current_user)
saha = Restaurant.create!(name:  "Saha", picture: Rails.root.join("public/uploads/restaurant/picture/2/mo.jpg").open).users.append(current_user)
taco = Restaurant.create!(name:  "Tacolicious", picture: Rails.root.join("public/uploads/restaurant/picture/3/Tacolicious_3_tacos.jpg").open).users.append(current_user)

restaurants = Restaurant.order(:created_at).take(6)
restaurants.each { |restaurant| 
Faker::Number.positive(3,15).times do
  restaurant.parties.create!(name: Faker::Name.first_name, size: Faker::Number.positive(1,10), phone: Faker::PhoneNumber.phone_number) 
end
}
  
  


