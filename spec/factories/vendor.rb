# frozen_string_literal: true

FactoryBot.define do
  factory :vendor do
    shopify_id { Faker::Alphanumeric.alpha }
    user_id { Faker::Alphanumeric.alpha }
    collection_id { Faker::Alphanumeric.alpha }
  end
end
