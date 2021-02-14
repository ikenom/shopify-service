# frozen_string_literal: true

class CreateVendorCollectionJob < ApplicationJob
  queue_as :default

  def perform(user_id:, business_name:, shopify_id:)
    raise "Vendor with business name: #{business_name} already exists" if Vendor.where(business_name: business_name).exists?

    vendor_service = VendorService.new
    collection_id = vendor_service.create_collection(business_name: business_name)

    Vendor.create!({
                     user_id: user_id,
                     shopify_id: shopify_id,
                     collection_id: collection_id,
                     business_name: business_name
                   })

    CreateVendorExporterJob.perform_later(user_id: user_id)
  end
end
