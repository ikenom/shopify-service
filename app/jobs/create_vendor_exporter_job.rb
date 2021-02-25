# frozen_string_literal: true

class CreateVendorExporterJob < ApplicationJob
  queue_as :shopify_service_create_vendor_exporter

  def perform(sender_id:, vendor_id:)
    Hutch.connect

    vendor = Vendor.find(vendor_id)
    Hutch.publish("shopify.vendor.created", sender_id: sender_id, shopify_id: vendor.shopify_id)
  end
end
