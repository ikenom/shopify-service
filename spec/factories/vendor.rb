# frozen_string_literal: true

FactoryBot.define do
  factory :vendor do
    shopify_id { Faker::Alphanumeric.alpha }
    collection_id { Faker::Alphanumeric.alpha }
    business_name { Faker::Restaurant.name }
  end
end
