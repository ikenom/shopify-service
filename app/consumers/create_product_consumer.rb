# frozen_string_literal: true

class CreateProductConsumer
  include Hutch::Consumer
  consume "shopify.product.create"
  queue_name "consumer_shopify_service_create_product"

  def process(message)
    CreateProductJob.perform_later(
      sender_id: message[:sender_id],
      vendor_id: message[:vendor_id],
      product_type: message[:product_type],
      product_name: message[:product_name],
      tags: message[:tags],
      price: message[:price]
    )
  end
end
