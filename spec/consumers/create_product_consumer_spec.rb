# frozen_string_literal: true

RSpec.describe CreateProductConsumer do
  let(:message) do
    {
      vendor_user_id: Faker::Alphanumeric.alpha,
      product_type: Faker::Alphanumeric.alpha,
      product_name: Faker::Alphanumeric.alpha,
      tags: [Faker::Alphanumeric.alpha],
      price: Faker::Alphanumeric.alpha
    }
  end
  subject(:consumer) { described_class.new }

  before(:each) do
    ActiveJob::Base.queue_adapter = :test
  end

  it "should enqueue create product jobs" do
    consumer.process(message)
    expect(CreateProductJob).to have_been_enqueued.with(hash_including({
                                                                         vendor_user_id: message[:vendor_user_id],
                                                                         product_type: message[:product_type],
                                                                         product_name: message[:product_name],
                                                                         tags: message[:tags],
                                                                         price: message[:price]
                                                                       }))
  end
end
