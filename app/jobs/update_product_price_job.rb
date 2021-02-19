# frozen_string_literal: true

class UpdateProductPriceJob < ApplicationJob
  queue_as :shopify_service_update_product_price

  def perform(product_variant_id:, price:)
    raise "Product with product_variant_id: #{product_variant_id} does not exists" unless Product.where(variant_id: product_variant_id).exists?

    product_service = ProductService.new
    product_service.update_product_price(product_variant_id: product_variant_id, price: price)
  end
end
