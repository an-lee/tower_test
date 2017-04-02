# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# create_admin_account = User.create([email: 'admin@testmail.com', password: '111111', password_confirmation: '111111', is_admin: 'true'])
# puts "Admin account created."
create_normal_account = User.create([email: 'test@example.com', password: '111111', password_confirmation: '111111'])
puts "Normal account created."
