FactoryGirl.define do
  factory :contact do
    sequence(:name)     { Faker::Name.name }
    sequence(:sex)      { %w(male female).sample }
    sequence(:birthday) { |n| n.years.ago }
    sequence(:phone)    { Faker::PhoneNumber.phone_number }
    sequence(:email)    { Faker::Internet.email }
  end

  factory :address do
    sequence(:street)   { Faker::Address.street_address }
    sequence(:city)     { Faker::Address.city }
    sequence(:state)    { Faker::Address.state_abbr }
    sequence(:postcode) { Faker::Address.postcode }

    contact
  end
end
