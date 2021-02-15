# frozen_string_literal: true

RSpec.describe CreateProductExporterJob, type: :job do
  let(:vendor_user_id) { Faker::Alphanumeric.alpha }
  let(:product_name) { Faker::Alphanumeric.alpha }

  subject(:perform) do
    described_class.perform_now(vendor_user_id: vendor_user_id, product_name: product_name)
  end

  before(:each) do
    allow(Hutch).to receive(:connect)
    allow(Hutch).to receive(:publish)
    ActiveJob::Base.queue_adapter = :test
  end

  it "should export product" do
    expect(Hutch).to receive(:publish).with("shopify.product.created", {
                                              user_id: vendor_user_id,
                                              product_name: product_name
                                            })
    perform
  end
end
