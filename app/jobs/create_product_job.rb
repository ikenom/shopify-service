# frozen_string_literal: true

class CreateProductJob < ApplicationJob
  queue_as :shopify_service_create_product

  def perform(sender_id:, vendor_id:, product_type:, product_name:, tags:, price:)
    vendor = Vendor.where(shopify_id: vendor_id).first

    raise "Vendor id: #{vendor_id} does not exist" if vendor.nil?
    raise "Product with name: #{product_name} exists on vendor with shopify id #{vendor_id}" if vendor.products.any? { |product| product.name == product_name }

    result = ProductService.new.create_product(business_name: vendor.business_name, product_type: product_type, collection_to_join: vendor.collection_id, product_name: product_name, tags: tags)
    product = Product.create!({
                                name: product_name,
                                shopify_id: result[:shopify_id],
                                variant_id: result[:variant_id],
                                vendor: vendor
                              })

    UpdateProductPriceJob.perform_later(product_variant_id: result[:variant_id], price: price)
    CreateProductExporterJob.perform_later(sender_id: sender_id, product_id: product.id.to_s)
  end
end
