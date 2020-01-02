require "faker"

FactoryBot.define do
  factory :user do |f|
    f.name {Faker::Name.name}
    f.email {Faker::Internet.email}
    f.password {Faker::Internet.password}
    f.confirmed_at {Time.zone.now}
    f.role { "user" }
  end

  factory :admin, parent: :user do |f|
    f.role { "admin" }
  end
end
