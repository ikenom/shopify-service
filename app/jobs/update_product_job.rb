# frozen_string_literal: true

class UpdateProductJob < ApplicationJob
  queue_as :shopify_service_update_product

  def perform(sender_id:, product_id:, price:, product_name:, tags:)
    product = Product.where(shopify_id: product_id).first
    raise "Product with shopify_id: #{product_id} does not exists" if product.nil?

    ProductService.new.update_product(product_shopify_id: product.shopify_id, tags: tags, product_name: product_name)

    UpdateProductPriceJob.perform_later(product_variant_id: product.variant_id, price: price)
    UpdateProductExporterJob.perform_later(sender_id: sender_id, product_id: product.id.to_s)
  end
end
