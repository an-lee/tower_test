# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# create_admin_account = User.create([email: 'admin@testmail.com', password: '111111', password_confirmation: '111111', is_admin: 'true'])
# puts "Admin account created."
create_normal_account = User.create([email: 'test1@example.com', password: '111111', password_confirmation: '111111', name: "Mike"])
puts "Mike created."
create_normal_account = User.create([email: 'test2@example.com', password: '111111', password_confirmation: '111111', name: "Jack"])
puts "Jack created."
create_normal_account = User.create([email: 'test3@example.com', password: '111111', password_confirmation: '111111', name: "Tom"])
puts "Tom created."
create_normal_account = User.create([email: 'test4@example.com', password: '111111', password_confirmation: '111111', name: "Jim"])
puts "Jim created."
create_normal_account = User.create([email: 'test5@example.com', password: '111111', password_confirmation: '111111', name: "Helen"])
puts "Helen created."
create_normal_account = User.create([email: 'test6@example.com', password: '111111', password_confirmation: '111111', name: "Jaden"])
puts "Jaden created."
