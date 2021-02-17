# frozen_string_literal: true

class UpdateProductJob < ApplicationJob
  queue_as :shopify_service_update_product

  def perform(vendor_user_id:, price:, product_name:, tags:)
    raise "Vendor with user id: #{vendor_user_id} does not exist" unless Vendor.where(user_id: vendor_user_id).exists?

    vendor = Vendor.where(user_id: vendor_user_id).first

    raise "Product with name: #{product_name} does not exists on vendor with user id #{vendor_user_id}" unless vendor.products.any? { |product| product.name == product_name }

    product = Vendor.last.products.where { |p| p.name == product_name }.first

    product_service = ProductService.new
    product_service.update_product(product_shopify_id: product.shopify_id, tags: tags, product_name: product_name)

    UpdateProductPriceJob.perform_later(product_variant_id: product.variant_id, price: price)
    UpdateProductExporterJob.perform_later(vendor_user_id: vendor_user_id, product_name: product_name)
  end
end
