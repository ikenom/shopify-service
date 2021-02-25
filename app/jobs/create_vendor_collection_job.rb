# frozen_string_literal: true

class CreateVendorCollectionJob < ApplicationJob
  queue_as :shopify_service_create_vendor_collection

  def perform(sender_id:, business_name:, phone:, shopify_id:)
    collection_id = VendorService.new.create_collection(business_name: business_name)
    vendor = Vendor.create!({
                              shopify_id: shopify_id,
                              collection_id: collection_id,
                              business_name: business_name,
                              phone: phone
                            })

    CreateVendorExporterJob.perform_later(sender_id: sender_id, vendor_id: vendor.id.to_s)
  end
end
