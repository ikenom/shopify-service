# frozen_string_literal: true

RSpec.describe UpdateProductConsumer do
  let(:message) do
    {
      vendor_user_id: Faker::Alphanumeric.alpha,
      product_name: Faker::Alphanumeric.alpha,
      tags: [Faker::Alphanumeric.alpha],
      price: Faker::Alphanumeric.alpha
    }
  end
  subject(:consumer) { described_class.new }

  before(:each) do
    ActiveJob::Base.queue_adapter = :test
  end

  it "should enqueue update product job" do
    consumer.process(message)
    expect(UpdateProductJob).to have_been_enqueued.with(hash_including({
                                                                         vendor_user_id: message[:vendor_user_id],
                                                                         product_name: message[:product_name],
                                                                         tags: message[:tags],
                                                                         price: message[:price]
                                                                       }))
  end
end
