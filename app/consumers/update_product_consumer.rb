# frozen_string_literal: true

class UpdateProductConsumer
  include Hutch::Consumer
  consume "shopify.product.update"
  queue_name "consumer_shopify_service_update_product"

  def process(message)
    UpdateProductJob.perform_later(
      vendor_user_id: message[:vendor_user_id],
      product_name: message[:product_name],
      tags: message[:tags],
      price: message[:price]
    )
  end
end
