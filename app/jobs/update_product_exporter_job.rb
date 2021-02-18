# frozen_string_literal: true

class UpdateProductExporterJob < ApplicationJob
  queue_as :shopify_service_update_product_exporter

  def perform(vendor_user_id:, product_name:)
    Hutch.connect
    Hutch.publish("shopify.product.updated", {
                    vendor_user_id: vendor_user_id,
                    product_name: product_name
                  })
  end
end
