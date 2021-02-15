# frozen_string_literal: true

class UpdateProductJob < ApplicationJob
  queue_as :shopify_service_update_product

  def perform(vendor_user_id:, product_shopify_id:, product_variant_id:, price:, product_name:)
    raise "Vendor with user id: #{vendor_user_id} does not exist" unless Vendor.where(user_id: vendor_user_id).exists?
    raise "Product with product_variant_id: #{product_variant_id} exists" if Product.where(variant_id: product_variant_id).exists?

    vendor = Vendor.where(user_id: vendor_user_id).first

    product_service = ProductService.new
    product_service.update_product_price(product_variant_id: product_variant_id, price: price)

    Product.create!({
                      shopify_id: product_shopify_id,
                      variant_id: product_variant_id,
                      vendor: vendor
                    })

    CreateProductExporterJob.perform_later(vendor_user_id: vendor_user_id, product_name: product_name)
  end
end
