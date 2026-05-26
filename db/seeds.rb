# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

VeterinaryClinic.destroy_all

VeterinaryClinic.create!([
  {
    name: "Kuching Veterinary Clinic",
    address: "123 Jalan Padungan, Kuching, Sarawak",
    latitude: 1.5497,
    longitude: 110.3592,
    phone: "+60 82-123456",
    open_hours: "Mon:08:00-18:00,Tue:08:00-18:00,Wed:08:00-18:00,Thu:08:00-18:00,Fri:08:00-18:00,Sat:09:00-13:00",
    is_emergency: false,
    accepted_species: "Dog,Cat,Rabbit,Hamster",
    last_verified_at: Date.today
  },
  {
    name: "24Hr Pet Emergency Centre",
    address: "45 Jalan Song, Kuching, Sarawak",
    latitude: 1.5321,
    longitude: 110.3712,
    phone: "+60 82-654321",
    open_hours: "Mon:00:00-23:59,Tue:00:00-23:59,Wed:00:00-23:59,Thu:00:00-23:59,Fri:00:00-23:59,Sat:00:00-23:59,Sun:00:00-23:59",
    is_emergency: true,
    accepted_species: "Dog,Cat",
    last_verified_at: Date.today
  }
])