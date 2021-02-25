# frozen_string_literal: true

class UpdateProductExporterJob < ApplicationJob
  queue_as :shopify_service_update_product_exporter

  def perform(sender_id:, product_id:)
    Hutch.connect
    product = Product.find(product_id)
    Hutch.publish("shopify.product.updated", {
                    sender_id: sender_id,
                    product_id: product.shopify_id
                  })
  end
end
