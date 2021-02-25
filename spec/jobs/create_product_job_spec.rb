# frozen_string_literal: true

RSpec.describe CreateProductJob, type: :job do
  let(:sender_id) { Faker::Alphanumeric.alpha }
  let(:vendor) { create(:vendor) }
  let(:product_type) { Faker::Restaurant.type }
  let(:product_name) { Faker::Food.dish }
  let(:tags) { [Faker::Name.name] }
  let(:price) { Faker::Commerce.price(range: 0..10.0, as_string: true) }

  let(:payload) do
    {
      shopify_id: Faker::Alphanumeric.alpha,
      variant_id: Faker::Alphanumeric.alpha
    }
  end

  subject(:perform) do
    described_class.perform_now(
      sender_id: sender_id,
      vendor_id: vendor.shopify_id,
      product_type: product_type,
      product_name: product_name,
      tags: tags,
      price: price
    )
  end

  before(:each) do
    ActiveJob::Base.queue_adapter = :test

    allow_any_instance_of(ProductService).to receive(:create_product).and_return(payload)
  end

  it "should queue UpdateProductPriceJob" do
    perform
    expect(UpdateProductPriceJob).to have_been_enqueued.with({
                                                               product_variant_id: payload[:variant_id],
                                                               price: price
                                                             })
  end

  it "should create new product" do
    expect { perform }.to change { Product.count }.by(1)

    product = Product.last
    expect(product.shopify_id).to eq(payload[:shopify_id])
    expect(product.variant_id).to eq(payload[:variant_id])
  end

  it "should not create product because vendor does not exist" do
    vendor.delete
    expect { perform }.to raise_error(RuntimeError)
  end

  it "should not create product because product with same name exist on vendor" do
    create(:product, name: product_name, vendor: vendor)
    expect { perform }.to raise_error(RuntimeError)
  end
end
