# frozen_string_literal: true

class CreateProductExporterJob < ApplicationJob
  queue_as :shopify_service_create_product_exporter

  def perform(sender_id:, product_id:)
    Hutch.connect

    product = Product.find(product_id)
    Hutch.publish("shopify.product.created", { sender_id: sender_id, shopify_id: product.shopify_id })
  end
end
