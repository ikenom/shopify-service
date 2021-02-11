FactoryBot.define do
  factory :vendor do
    shopify_id { Faker::Alphanumeric.alpha }
    ecommerce_id { Faker::Alphanumeric.alpha }
    collection_id { Faker::Alphanumeric.alpha }
  end
end