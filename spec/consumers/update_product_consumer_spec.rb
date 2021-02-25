# frozen_string_literal: true

RSpec.describe UpdateProductConsumer do
  let(:message) do
    {
      sender_id: Faker::Alphanumeric.alpha,
      product_id: Faker::Alphanumeric.alpha,
      product_name: Faker::Food.dish,
      tags: [],
      price: Faker::Commerce.price(range: 0..10.0, as_string: true)
    }
  end
  subject(:consumer) { described_class.new }

  before(:each) do
    ActiveJob::Base.queue_adapter = :test
  end

  it "should enqueue update product job" do
    consumer.process(message)
    expect(UpdateProductJob).to have_been_enqueued.with(hash_including({
                                                                         sender_id: message[:sender_id],
                                                                         product_id: message[:product_id],
                                                                         product_name: message[:product_name],
                                                                         price: message[:price],
                                                                         tags: message[:tags]
                                                                       }))
  end
end
