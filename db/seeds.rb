# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# create_admin_account = User.create([email: 'admin@testmail.com', password: '111111', password_confirmation: '111111', is_admin: 'true'])
# puts "Admin account created."
user_1 = User.create(email: 'test1@example.com', password: '111111', password_confirmation: '111111', name: "Mike")
puts "Mike created."
user_2 = User.create(email: 'test2@example.com', password: '111111', password_confirmation: '111111', name: "Jack")
puts "Jack created."
user_3 = User.create(email: 'test3@example.com', password: '111111', password_confirmation: '111111', name: "Tom")
puts "Tom created."


team_1 = Team.create(
    title: "Team No.1",
    description: "This is Team No.1, created by Mike and it's a greate team!",
    user_id: user_1.id)
user_1.join_team!(team_1)
user_2.join_team!(team_1)
puts "team_1 created."

team_2 = Team.create!(
    title: "Team No.2",
    description: "This is Team No.2, created by Mike and it's a greate team!",
    user: user_2)
user_2.join_team!(team_2)
user_3.join_team!(team_2)
puts "team_2 created."

project_1 = Project.create!(
    title: "Project No.1, from Team No.1",
    description: "This is Project No.1, belong to Team No.1 created by Mike!",
    user: user_1,
    team: team_1)
user_1.join_project!(project_1)
user_3.join_project!(project_1)
puts "team_3 created."

project_2 = Project.create!(
    title: "Project No.2, from Team No.1",
    description: "This is Project No.1, belong to Team No.1 created by Mike!",
    user: user_1,
    team: team_1)
user_1.join_project!(project_2)
user_3.join_project!(project_2)
puts "project_2 created."

project_3 = Project.create!(
    title: "Project No.3, from Team No.1",
    description: "This is Project No.1, belong to Team No.1 created by Mike!",
    user: user_2,
    team: team_2)
user_2.join_project!(project_3)
user_3.join_project!(project_3)
puts "project_3 created."

project_4 = Project.create!(
    title: "Project No.4, from Team No.1",
    description: "This is Project No.1, belong to Team No.1 created by Mike!",
    user: user_2,
    team: team_2)
user_2.join_project!(project_4)
user_3.join_project!(project_4)
puts "project_4 created."

todos = for i in 1..10 do
  Todo.create!([title: "Todo No.#{i}", user: user_1, team: team_1, project: project_1])
  Todo.last.update(assign: user_3.name, user: user_1)
  Todo.last.update(assign: user_1.name, user: user_3)
  Todo.last.update(due: Date.yesterday, user: user_1)
  Todo.last.update(due: Date.tomorrow, user: user_3)
  Todo.last.update(is_trash: true, user: user_1)
  Todo.last.update(is_trash: false, user: user_1)
  Todo.last.update(is_completed: true, user: user_3)
  Todo.last.update(is_completed: false, user: user_3)
  Message.create(content: "Message #{i} from #{user_3.name}" , todo: Todo.last, project: project_1, user: user_3 )
  Message.create(content: "Message #{i} from #{user_1.name}" , todo: Todo.last, project: project_1, user: user_1 )
end
todos = for i in 1..10 do
  Todo.create!([title: "Todo No.#{i}", user: user_3, team: team_1, project: project_2])
  Todo.last.update(assign: user_3.name, user: user_1)
  Todo.last.update(assign: user_1.name, user: user_3)
  Todo.last.update(due: Date.yesterday, user: user_1)
  Todo.last.update(due: Date.tomorrow, user: user_3)
  Todo.last.update(is_trash: true, user: user_3)
  Todo.last.update(is_trash: false, user: user_1)
  Todo.last.update(is_completed: true, user: user_3)
  Todo.last.update(is_completed: false, user: user_3)
  Message.create(content: "Message #{i} from #{user_3.name}" , todo: Todo.last, project: project_1, user: user_3 )
  Message.create(content: "Message #{i} from #{user_1.name}" , todo: Todo.last, project: project_1, user: user_1 )
end
todos = for i in 1..10 do
  Todo.create!([title: "Todo No.#{i}", user: user_2, team: team_2, project: project_3])
  Todo.last.update(assign: user_3.name, user: user_2)
  Todo.last.update(assign: user_2.name, user: user_3)
  Todo.last.update(due: Date.yesterday, user: user_2)
  Todo.last.update(due: Date.tomorrow, user: user_3)
  Todo.last.update(is_trash: true, user: user_2)
  Todo.last.update(is_trash: false, user: user_2)
  Todo.last.update(is_completed: true, user: user_3)
  Todo.last.update(is_completed: false, user: user_3)
  Message.create(content: "Message #{i} from #{user_3.name}" , todo: Todo.last, project: project_3, user: user_3 )
  Message.create(content: "Message #{i} from #{user_2.name}" , todo: Todo.last, project: project_3, user: user_2 )
end
todos = for i in 1..10 do
  Todo.create!([title: "Todo No.#{i}", user: user_3, team: team_2, project: project_4])
  Todo.last.update(assign: user_3.name, user: user_2)
  Todo.last.update(assign: user_2.name, user: user_3)
  Todo.last.update(due: Date.yesterday, user: user_2)
  Todo.last.update(due: Date.tomorrow, user: user_3)
  Todo.last.update(is_trash: true, user: user_3)
  Todo.last.update(is_trash: false, user: user_2)
  Todo.last.update(is_completed: true, user: user_3)
  Todo.last.update(is_completed: false, user: user_3)
  Message.create(content: "Message #{i} from #{user_3.name}" , todo: Todo.last, project: project_4, user: user_3 )
  Message.create(content: "Message #{i} from #{user_2.name}" , todo: Todo.last, project: project_4, user: user_2 )
end
puts "todos created."
