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

Restaurant.create!(name:  "Delfina").users.append(current_user)
Restaurant.create!(name:  "Saha").users.append(current_user)
Restaurant.create!(name:  "Tacolicious").users.append(current_user)

restaurants = Restaurant.order(:created_at).take(6)
restaurants.each { |restaurant| 
Faker::Number.positive(3,15).times do
  restaurant.parties.create!(name: Faker::Name.first_name, size: Faker::Number.positive(1,10), phone: Faker::PhoneNumber.phone_number) 
end
}
  
  


