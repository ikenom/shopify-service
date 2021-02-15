# frozen_string_literal: true

class CreateProductConsumer
  include Hutch::Consumer
  consume "shopify.product.create"

  def process(message)
    CreateProductJob.perform_later(
      vendor_user_id: message[:vendor_user_id],
      product_type: message[:product_type],
      product_name: message[:product_name],
      tags: message[:tags],
      price: message[:price]
    )
  end
end
