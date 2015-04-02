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

current_user = User.create!(first_name:  Faker::Name.first_name,
             last_name: Faker::Name.last_name,
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     false,
             activated: true,
             activated_at: Time.zone.now)

other_user = User.create!(first_name:  Faker::Name.first_name,
             last_name: Faker::Name.last_name,
             email: "admin@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)
             
another_user = User.create!(first_name:  Faker::Name.first_name,
             last_name: Faker::Name.last_name,
             email: "example1@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     false,
             activated: true,
             activated_at: Time.zone.now)
             
delfina = Restaurant.create!(name:  "Delfina", est_wait_time: 20.minutes, picture: Rails.root.join("public/uploads/restaurant/picture/1/8.jpg").open).users.append(current_user)
saha = Restaurant.create!(name:  "Saha",  picture: Rails.root.join("public/uploads/restaurant/picture/2/mo.jpg").open).users.append(another_user)
taco = Restaurant.create!(name:  "Tacolicious", est_wait_time: 24.minutes,  picture: Rails.root.join("public/uploads/restaurant/picture/3/Tacolicious_3_tacos.jpg").open).users.append(another_user)
kitchenstory = Restaurant.create!(name:  "Kitchen Story", est_wait_time: 45.minutes, picture: Rails.root.join("public/uploads/restaurant/picture/5/kitchenstory1.jpg").open).users.append(current_user)
nopa = Restaurant.create!(name:  "NOPA", est_wait_time: 35.minutes, picture: Rails.root.join("public/uploads/restaurant/picture/6/IMG_1089_900_240_s_c1__1_.jpg").open).users.append(current_user)
orenchi = Restaurant.create!(name:  "Orenchi", est_wait_time: 55.minutes,  picture: Rails.root.join("public/uploads/restaurant/picture/4/06.jpg").open).users.append(another_user)

restaurants = Restaurant.order(:created_at).take(6)
restaurants.each { |restaurant| 
Faker::Number.positive(3,15).times do
  restaurant.parties.create!(name: Faker::Name.first_name, size: Faker::Number.positive(1,10), phone: Faker::PhoneNumber.phone_number) 
end
}
  
  


