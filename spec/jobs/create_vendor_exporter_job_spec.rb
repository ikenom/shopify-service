# frozen_string_literal: true

RSpec.describe CreateVendorExporterJob, type: :job do
  let(:sender_id) { Faker::Alphanumeric.alpha }
  let(:vendor) { create(:vendor) }

  subject(:perform) do
    described_class.perform_now(vendor_id: vendor.id.to_s, sender_id: sender_id)
  end

  before(:each) do
    allow(Hutch).to receive(:connect)
    allow(Hutch).to receive(:publish)
    ActiveJob::Base.queue_adapter = :test
  end

  it "should export vendor" do
    expect(Hutch).to receive(:publish).with("shopify.vendor.created", sender_id: sender_id, shopify_id: vendor.shopify_id)
    perform
  end
end
