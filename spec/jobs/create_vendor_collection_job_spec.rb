# frozen_string_literal: true

RSpec.describe CreateVendorCollectionJob, type: :job do
  let(:business_name) { Faker::Restaurant.name }
  let(:phone) { Faker::PhoneNumber.cell_phone }
  let(:sender_id) { Faker::Alphanumeric.alpha }
  let(:shopify_id) { Faker::Alphanumeric.alpha }
  let(:collection_id) { Faker::Alphanumeric.alpha }

  subject(:perform) do
    described_class.perform_now(
      sender_id: sender_id,
      business_name: business_name,
      phone: phone,
      shopify_id: shopify_id
    )
  end

  before(:each) do
    ActiveJob::Base.queue_adapter = :test
    allow_any_instance_of(VendorService).to receive(:create_collection).and_return(collection_id)
  end

  it "should queue CreateVendorExporterJob" do
    perform
    vendor = Vendor.last
    expect(CreateVendorExporterJob).to have_been_enqueued.with(vendor_id: vendor.id.to_s, sender_id: sender_id)
  end

  it "should create new vendor" do
    expect { perform }.to change { Vendor.count }.by(1)
    vendor = Vendor.last

    expect(vendor.business_name).to eq(business_name)
    expect(vendor.phone).to eq(phone)
    expect(vendor.shopify_id).to eq(shopify_id)
    expect(vendor.collection_id).to eq(collection_id)
  end
end
