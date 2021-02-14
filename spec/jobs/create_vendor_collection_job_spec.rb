
RSpec.describe CreateVendorCollectionJob, :vcr ,type: :job do
  let(:user_id) { Faker::Internet.email }
  let(:business_name) { Faker::Alphanumeric.alpha }
  let(:shopify_id) { Faker::Alphanumeric.alpha }

  subject(:perform) do
    described_class.perform_now(
      user_id: user_id,
      business_name: business_name,
      shopify_id: shopify_id
    )
  end

  before(:each) do
    ActiveJob::Base.queue_adapter = :test
  end

  it "should queue CreateVendorExporterJob" do
    perform
    expect(CreateVendorExporterJob).to have_been_enqueued.with(user_id: user_id) 
  end

  it "should create new vendor" do
    expect { perform }.to change { Vendor.count }.by(1)
    vendor = Vendor.last

    expect(vendor.user_id).to eq(user_id)
    expect(vendor.business_name).to eq(business_name)
    expect(vendor.shopify_id).to eq(shopify_id)
    expect(vendor.collection_id).not_to eq(nil)
  end

  it "should not create vendor because business_name already exist" do
    Vendor.create!({
      user_id: user_id,
      shopify_id: shopify_id,
      collection_id: "1",
      business_name: business_name
    })
    expect { perform }.to raise_error(RuntimeError)
  end

end