# frozen_string_literal: true

RSpec.describe UpdateProductJob, :vcr, type: :job do
  let(:vendor_user_id) { "15" }
  let(:product_shopify_id) { "gid://shopify/Product/6216557658309" }
  let(:product_variant_id) { "gid://shopify/ProductVariant/38122727637189" }
  let(:product_name) { "Kristofer Boyle DO" }
  let(:price) { "2.00" }

  subject(:perform) do
    described_class.perform_now(
      vendor_user_id: vendor_user_id,
      product_shopify_id: product_shopify_id,
      product_variant_id: product_variant_id,
      product_name: product_name,
      price: price
    )
  end

  before(:each) do
    ActiveJob::Base.queue_adapter = :test
  end

  it "should create new product" do
    vendor = Vendor.create!({
                              user_id: vendor_user_id,
                              shopify_id: "gid://shopify/Customer/4636651290821",
                              collection_id: "gid://shopify/Collection/244474642629",
                              business_name: "test name"
                            })
    expect { perform }.to change { Product.count }.by(1)
    product = Product.last

    expect(product.shopify_id).to eq(product_shopify_id)
    expect(product.variant_id).to eq(product_variant_id)
    expect(product.vendor).to eq(vendor)
  end

  it "should queue CreateProductExporterJob" do
    Vendor.create!({
                     user_id: vendor_user_id,
                     shopify_id: "gid://shopify/Customer/4636651290821",
                     collection_id: "gid://shopify/Collection/244474642629",
                     business_name: "test name"
                   })
    perform
    expect(CreateProductExporterJob).to have_been_enqueued.with(hash_including(
                                                                  vendor_user_id: vendor_user_id,
                                                                  product_name: product_name
                                                                ))
  end

  it "should not create product because vendor does not exist" do
    expect { perform }.to raise_error(RuntimeError)
  end

  it "should not create product because product with same name exist" do
    vendor = Vendor.create!({
                              user_id: vendor_user_id,
                              shopify_id: "gid://shopify/Customer/4636651290821",
                              collection_id: "gid://shopify/Collection/244474642629",
                              business_name: "test name"
                            })

    Product.create!({
                      shopify_id: product_shopify_id,
                      variant_id: product_variant_id,
                      vendor: vendor
                    })
    expect { perform }.to raise_error(RuntimeError)
  end
end
