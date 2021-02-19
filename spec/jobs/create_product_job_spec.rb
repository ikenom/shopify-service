# frozen_string_literal: true

RSpec.describe CreateProductJob, :vcr, type: :job do
  let(:vendor_user_id) { "15" }
  let(:product_type) { Faker::Alphanumeric.alpha }
  let(:product_name) { Faker::Name.name }
  let(:tags) { [Faker::Name.name] }
  let(:price) { "2.00" }

  let(:shopify_id) { "gid://shopify/Customer/4636651290821" }

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

  it "should queue UpdateProductPriceJob" do
    Vendor.create!({
                     user_id: vendor_user_id,
                     shopify_id: shopify_id,
                     collection_id: "gid://shopify/Collection/244474642629",
                     business_name: "test name"
                   })
    perform
    expect(UpdateProductPriceJob).to have_been_enqueued.with(hash_including(
                                                               :product_variant_id,
                                                               price: price
                                                             ))
  end

  it "should create new product" do
    vendor = Vendor.create!({
                              user_id: vendor_user_id,
                              shopify_id: shopify_id,
                              collection_id: "gid://shopify/Collection/244474642629",
                              business_name: "test name"
                            })
    expect { perform }.to change { Product.count }.by(1)
    product = Product.last

    expect(product.shopify_id).to match(%r{(gid://shopify/Product/)+([0-9]*)})
    expect(product.variant_id).not_to be_nil
    expect(product.vendor).to eq(vendor)
  end

  it "should not create product because vendor does not exist" do
    expect { perform }.to raise_error(RuntimeError)
  end

  it "should not create product because product with same name exist on vendor" do
    vendor = Vendor.create!({
                              user_id: vendor_user_id,
                              shopify_id: shopify_id,
                              collection_id: "gid://shopify/Collection/244474642629",
                              business_name: "test name"
                            })

    Product.create!({
                      shopify_id: "1",
                      variant_id: "1",
                      vendor: vendor,
                      name: product_name
                    })

    expect { perform }.to raise_error(RuntimeError)
  end
end
