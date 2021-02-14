RSpec.describe CreateVendorExporterJob, type: :job do
  let(:user_id) { Faker::Alphanumeric.alpha }

  subject(:perform) do
    described_class.perform_now(user_id: user_id)
  end

  before(:each) do
    allow(Hutch).to receive(:connect)
    allow(Hutch).to receive(:publish)
    ActiveJob::Base.queue_adapter = :test
  end

  it "should export vendor" do
    expect(Hutch).to receive(:publish).with("shopify.vendor.created", user_id: user_id)
    perform
  end
end