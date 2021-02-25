# frozen_string_literal: true

RSpec.describe UpdateProductJob, type: :job do
  let(:sender_id) { Faker::Alphanumeric.alpha }
  let(:product) { create(:product) }
  let(:product_name) { Faker::Food.dish }
  let(:tags) { [Faker::Name.name] }
  let(:price) { Faker::Commerce.price(range: 0..10.0, as_string: true) }

  subject(:perform) do
    described_class.perform_now(
      sender_id: sender_id,
      product_id: product.shopify_id,
      product_name: product_name,
      price: price,
      tags: tags
    )
  end

  before(:each) do
    ActiveJob::Base.queue_adapter = :test
    allow_any_instance_of(ProductService).to receive(:update_product)
  end

  it "should queue UpdateProductExporterJob" do
    perform
    expect(UpdateProductExporterJob).to have_been_enqueued.with({
                                                                  sender_id: sender_id,
                                                                  product_id: product.id.to_s
    })
  end

  it "should queue UpdateProdctPriceJob" do
    perform
    expect(UpdateProductPriceJob).to have_been_enqueued.with({
                                                               product_variant_id: product.variant_id,
                                                               price: price
    })
  end

  it "should fail to update product because product doesn't exist" do
    product.delete
    expect { perform }.to raise_error(RuntimeError)
  end
end
