# frozen_string_literal: true

RSpec.describe CreateVendorJob, :vcr, type: :job do
  let(:user_id) { Faker::Internet.email }
  let(:business_name) { Faker::Alphanumeric.alpha }
  let(:first_name) { Faker::Name.name }
  let(:last_name) { Faker::Name.name }
  let(:email) { "test1234@gmail.com" }
  let(:phone) { "5123439583" }

  subject(:perform) do
    described_class.perform_now(
      user_id: user_id,
      business_name: business_name,
      first_name: first_name,
      last_name: last_name,
      email: email,
      phone: phone
    )
  end

  before(:each) do
    ActiveJob::Base.queue_adapter = :test
  end

  it "should queue CreateVendorCollectionJob" do
    perform
    expect(CreateVendorCollectionJob).to have_been_enqueued.with(hash_including(
                                                                   :shopify_id,
                                                                   user_id: user_id,
                                                                   business_name: business_name
                                                                 ))
  end

  it "should not create vendor because of duplicate user_id" do
    Vendor.create!({
                     user_id: user_id,
                     shopify_id: "test",
                     collection_id: "1",
                     business_name: business_name
                   })
    expect { perform }.to raise_error(RuntimeError)
  end
end
