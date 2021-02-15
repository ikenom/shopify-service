# frozen_string_literal: true

class CreateProductJob < ApplicationJob
  queue_as :shopify_service_create_product

  def perform(vendor_user_id:, product_type:, product_name:, tags:, price:)
    raise "Vendor with user id: #{vendor_user_id} does not exist" unless Vendor.where(user_id: vendor_user_id).exists?

    vendor = Vendor.where(user_id: vendor_user_id).first
    product_service = ProductService.new
    result = product_service.create_product(business_name: vendor.business_name, product_type: product_type, collection_to_join: vendor.collection_id, product_name: product_name, tags: tags)

    UpdateProductJob.perform_later(vendor_user_id: vendor_user_id, product_shopify_id: result[:shopify_id], product_variant_id: result[:variant_id], price: price, product_name: product_name)
  end
end
