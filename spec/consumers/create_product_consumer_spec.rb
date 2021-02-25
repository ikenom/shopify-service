# frozen_string_literal: true

RSpec.describe CreateProductConsumer do
  let(:message) do
    {
      sender_id: Faker::Alphanumeric.alpha,
      vendor_id: Faker::Alphanumeric.alpha,
      product_type: Faker::Restaurant.type,
      product_name: Faker::Restaurant.name,
      tags: [],
      price: Faker::Commerce.price(range: 0..10.0, as_string: true)
    }
  end
  subject(:consumer) { described_class.new }

  before(:each) do
    ActiveJob::Base.queue_adapter = :test
  end

  it "should enqueue create product jobs" do
    consumer.process(message)
    expect(CreateProductJob).to have_been_enqueued.with(hash_including({
                                                                         sender_id: message[:sender_id],
                                                                         vendor_id: message[:vendor_id],
                                                                         product_type: message[:product_type],
                                                                         product_name: message[:product_name],
                                                                         tags: message[:tags],
                                                                         price: message[:price]
                                                                       }))
  end
end
