# frozen_string_literal: true

RSpec.describe CreateProductJob, :vcr, type: :job do
  let(:vendor_user_id) { "15" }
  let(:product_type) { Faker::Alphanumeric.alpha }
  let(:product_name) { Faker::Name.name }
  let(:tags) { [Faker::Name.name] }
  let(:price) { "2.00" }

  subject(:perform) do
    described_class.perform_now(
      vendor_user_id: vendor_user_id,
      product_type: product_type,
      product_name: product_name,
      tags: tags,
      price: price
    )
  end

  before(:each) do
    ActiveJob::Base.queue_adapter = :test
  end

  it "should queue UpdateProductJob" do
    Vendor.create!({
                     user_id: vendor_user_id,
                     shopify_id: "gid://shopify/Customer/4636651290821",
                     collection_id: "gid://shopify/Collection/244474642629",
                     business_name: "test name"
                   })
    perform
    expect(UpdateProductJob).to have_been_enqueued.with(hash_including(
                                                          :product_shopify_id,
                                                          :product_variant_id,
                                                          vendor_user_id: vendor_user_id,
                                                          price: price,
                                                          product_name: product_name
                                                        ))
  end

  it "should not create product because vendor does not exist" do
    expect { perform }.to raise_error(RuntimeError)
  end
end
