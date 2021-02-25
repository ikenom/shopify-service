# frozen_string_literal: true

RSpec.describe CreateProductExporterJob, type: :job do
  let(:sender_id) { Faker::Alphanumeric.alpha }
  let(:product) { create(:product) }

  subject(:perform) do
    described_class.perform_now(sender_id: sender_id, product_id: product.id.to_s)
  end

  before(:each) do
    allow(Hutch).to receive(:connect)
    allow(Hutch).to receive(:publish)

    ActiveJob::Base.queue_adapter = :test
  end

  it "should export product" do
    expect(Hutch).to receive(:publish).with("shopify.product.created", {
                                              sender_id: sender_id,
                                              shopify_id: product.shopify_id
                                            })
    perform
  end
end
