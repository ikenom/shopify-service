# frozen_string_literal: true

class CreateVendorJob < ApplicationJob
  queue_as :default

  def perform(user_id:, business_name:, first_name:, last_name:, email:, phone:)
    raise "Vendor with user id: #{user_id} already exists" if Vendor.where(user_id: user_id).exists?

    customer_service = CustomerService.new
    shopify_id = customer_service.create_customer(first_name: first_name, last_name: last_name, email: email, phone: phone, tags: ["vendor", "user_id:#{user_id}"])

    CreateVendorCollectionJob.perform_later(user_id: user_id, shopify_id: shopify_id, business_name: business_name)
  end
end
