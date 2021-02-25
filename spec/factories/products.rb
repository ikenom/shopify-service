# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { Faker::Alphanumeric.alpha }
    shopify_id { Faker::Alphanumeric.alpha }
    variant_id { Faker::Alphanumeric.alpha }
    vendor { build(:vendor) }
  end
end
