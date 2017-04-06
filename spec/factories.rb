FactoryGirl.define do
  sequence(:email) { |n| "user#{n}@example.com" }
  sequence(:title) { |n| "title_#{n}" }

  factory :user do
    name "Mike"
    email
    password "password"
    password_confirmation { password }
  end

  factory :team do
    title "team title"
    description "Description"
    user
  end

  factory :project do
    title "project titel"
    description "project description"
    user
    team
  end

  factory :todo do
    title "todo title"
    description "todo description"
    user
    team
    project
  end

  factory :message do
    content "message content"
    user
    project
    todo
  end

end
