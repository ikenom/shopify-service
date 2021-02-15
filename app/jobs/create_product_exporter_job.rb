# frozen_string_literal: true

class CreateProductExporterJob < ApplicationJob
  queue_as :default

  def perform(vendor_user_id:, product_name:)
    Hutch.connect
    Hutch.publish("shopify.product.created", { user_id: vendor_user_id, product_name: product_name })
  end
end
