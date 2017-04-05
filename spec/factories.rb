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
    title
    description "Description"
    user
  end
end
