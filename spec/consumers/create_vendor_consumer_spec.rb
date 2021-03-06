# frozen_string_literal: true

RSpec.describe CreateVendorConsumer do
  let(:message) do
    {
      sender_id: Faker::Alphanumeric.alpha,
      business_name: Faker::Alphanumeric.alpha,
      first_name: Faker::Alphanumeric.alpha,
      last_name: Faker::Alphanumeric.alpha,
      email: Faker::Alphanumeric.alpha,
      phone: Faker::Alphanumeric.alpha,
      tags: []
    }
  end
  subject(:consumer) { described_class.new }

  before(:each) do
    ActiveJob::Base.queue_adapter = :test
  end

  it "should enqueue create vendor jobs" do
    consumer.process(message)
    expect(CreateVendorJob).to have_been_enqueued.with(hash_including({
                                                                        sender_id: message[:sender_id],
                                                                        business_name: message[:business_name],
                                                                        first_name: message[:first_name],
                                                                        last_name: message[:last_name],
                                                                        email: message[:email],
                                                                        phone: message[:phone],
                                                                        tags: message[:tags]
                                                                      }))
  end
end
