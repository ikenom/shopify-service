# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    shopify_id { Faker::Alphanumeric.alpha }
    variant_id { Faker::Alphanumeric.alpha }
    vendor { build(:vendor) }
  end
end
