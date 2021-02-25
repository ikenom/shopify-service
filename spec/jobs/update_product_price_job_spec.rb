# frozen_string_literal: true

RSpec.describe UpdateProductPriceJob, type: :job do
  let(:product) { create(:product) }
  let(:price) { Faker::Commerce.price(range: 0..10.0, as_string: true) }

  subject(:perform) do
    described_class.perform_now(
      product_variant_id: product.variant_id,
      price: price
    )
  end

  before(:each) do
    ActiveJob::Base.queue_adapter = :test
    allow_any_instance_of(ProductService).to receive(:update_product_price)
  end

  it "should update product price" do
    expect_any_instance_of(ProductService).to receive(:update_product_price).with({
                                                                                    product_variant_id: product.variant_id, price: price
                                                                                  }).once

    perform
  end

  it "should not update product price because product does not exist" do
    product.delete
    expect { perform }.to raise_error(RuntimeError)
  end
end
