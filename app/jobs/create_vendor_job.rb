# frozen_string_literal: true

class CreateVendorJob < ApplicationJob
  queue_as :shopify_service_create_vendor

  def perform(sender_id:, business_name:, first_name:, last_name:, email:, phone:, tags:)
    raise "Vendor with phone number: #{phone} already exists" if Vendor.where(phone: phone).exists?
    raise "Vendor with business name: #{business_name} already exists" if Vendor.where(business_name: business_name).exists?

    tags << "vendor"
    tags << "name:#{business_name}"
    shopify_id = CustomerService.new.create_customer(first_name: first_name, last_name: last_name, email: email, phone: phone, tags: tags)
    CreateVendorCollectionJob.perform_later(sender_id: sender_id, shopify_id: shopify_id, business_name: business_name)
  end
end
