# frozen_string_literal: true

RSpec.describe UpdateProductJob, :vcr, type: :job do
  let(:vendor_user_id) { "15" }
  let(:product_shopify_id) { "gid://shopify/Product/6219386257605" }
  let(:product_variant_id) { "gid://shopify/ProductVariant/38133159133381" }
  let(:product_name) { "test_product_2" }
  let(:price) { "2.00" }
  let(:tags) { ["tag1"] }

  let(:vendor_shopify_id) { "gid://shopify/Customer/4641919598789" }
  let(:vendor_collection_id) { "gid://shopify/Collection/244742062277" }

  subject(:perform) do
    described_class.perform_now(
      vendor_user_id: vendor_user_id,
      product_name: product_name,
      price: price,
      tags: tags
    )
  end

  before(:each) do
    ActiveJob::Base.queue_adapter = :test
  end

  it "should queue UpdateProductExporterJob" do
    vendor = Vendor.create!({
                              user_id: vendor_user_id,
                              shopify_id: vendor_shopify_id,
                              collection_id: vendor_collection_id,
                              business_name: "test name"
                            })

    Product.create!({
                      shopify_id: product_shopify_id,
                      variant_id: product_variant_id,
                      vendor: vendor,
                      name: product_name
                    })
    perform
    expect(UpdateProductExporterJob).to have_been_enqueued.with(hash_including(
                                                                  vendor_user_id: vendor_user_id,
                                                                  product_name: product_name
                                                                ))
  end

  it "should queue UpdateProdctPriceJob" do
    vendor = Vendor.create!({
                              user_id: vendor_user_id,
                              shopify_id: vendor_shopify_id,
                              collection_id: vendor_collection_id,
                              business_name: "test name"
                            })
    Product.create!({
                      shopify_id: product_shopify_id,
                      variant_id: product_variant_id,
                      vendor: vendor,
                      name: product_name
                    })

    perform
    expect(UpdateProductPriceJob).to have_been_enqueued.with(hash_including(
                                                               :product_variant_id,
                                                               price: price
                                                             ))
  end

  it "should fail to update product because vendor doesn't exist" do
    expect { perform }.to raise_error(RuntimeError)
  end

  it "should fail to update product because product with product name doesn't exist on vendor" do
    Vendor.create!({
                     user_id: vendor_user_id,
                     shopify_id: vendor_shopify_id,
                     collection_id: vendor_collection_id,
                     business_name: "test name"
                   })
    expect { perform }.to raise_error(RuntimeError)
  end
end
