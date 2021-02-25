# frozen_string_literal: true

RSpec.describe CreateVendorJob, type: :job do
  let(:sender_id) { Faker::Alphanumeric.alpha }
  let(:business_name) { Faker::Alphanumeric.alpha }
  let(:phone) { Faker::PhoneNumber.cell_phone }
  let(:first_name) { Faker::Name.first_name }
  let(:last_name) { Faker::Name.last_name }
  let(:email) { Faker::Internet.email }
  let(:tags) { [] }

  let(:shopify_id) { Faker::Alphanumeric.alpha }

  subject(:perform) do
    described_class.perform_now(
      sender_id: sender_id,
      business_name: business_name,
      first_name: first_name,
      last_name: last_name,
      email: email,
      phone: phone,
      tags: ["tag1"]
    )
  end

  before(:each) do
    ActiveJob::Base.queue_adapter = :test
    allow_any_instance_of(CustomerService).to receive(:create_customer).and_return(shopify_id)
  end

  it "should queue CreateVendorCollectionJob" do
    perform
    expect(CreateVendorCollectionJob).to have_been_enqueued.with({
                                                                   shopify_id: shopify_id,
                                                                   sender_id: sender_id,
                                                                   business_name: business_name
                                                                 })
  end

  it "should not create vendor because of duplicate phone #" do
    create(:vendor, phone: phone)
    expect { perform }.to raise_error(RuntimeError)
  end

  it "should not create vendor because business_name already exist" do
    create(:vendor, business_name: business_name)
    expect { perform }.to raise_error(RuntimeError)
  end

  it "should add to tag list" do
    name = "name:#{business_name}"
    expect_any_instance_of(CustomerService).to receive(:create_customer).with(hash_including({ tags: ["tag1", "vendor", name] })).and_return(shopify_id)
    perform
  end
end
