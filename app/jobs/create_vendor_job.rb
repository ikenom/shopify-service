class CreateVendorJob < ApplicationJob
  queue_as :default

  def perform(ecommerce_id:, buisnessName:, firstName:, lastName:, email:, phone:)
    raise "Vendor with ecommerce id: #{ecommerce_id} already exists" if Vendor.where(ecommerce_id: ecommerce_id).exists?


  end
end