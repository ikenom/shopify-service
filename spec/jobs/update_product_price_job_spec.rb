# frozen_string_literal: true

RSpec.describe UpdateProductPriceJob, :vcr, type: :job do
  let(:shopify_id) { "gid://shopify/Customer/4636651290821" }
  let(:product_variant_id) { "gid://shopify/ProductVariant/38132815331525" }
  let(:price) { "2.00" }

  subject(:perform) do
    described_class.perform_now(
      product_variant_id: product_variant_id,
      price: price
    )
  end

  before(:each) do
    ActiveJob::Base.queue_adapter = :test
  end

  it "should update product price" do
    vendor = Vendor.create!({
                              user_id: "1",
                              shopify_id: shopify_id,
                              collection_id: "2",
                              business_name: "test name"
                            })

    Product.create!({
                      shopify_id: shopify_id,
                      variant_id: product_variant_id,
                      vendor: vendor,
                      name: "test"
                    })
    perform
  end

  it "should not update product price because product does not exist" do
    expect { perform }.to raise_error(RuntimeError)
  end
end
