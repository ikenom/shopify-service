# frozen_string_literal: true

class UpdateProductConsumer
  include Hutch::Consumer
  consume "shopify.product.update"
  queue_name "consumer_shopify_service_update_product"

  def process(message)
    UpdateProductJob.perform_later(
      sender_id: message[:sender_id],
      product_id: message[:product_id],
      product_name: message[:product_name],
      price: message[:price],
      tags: message[:tags]
    )
  end
end
