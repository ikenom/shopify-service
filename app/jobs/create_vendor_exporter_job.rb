# frozen_string_literal: true

class CreateVendorExporterJob < ApplicationJob
  queue_as :default

  def perform(user_id:)
    Hutch.connect
    Hutch.publish("shopify.vendor.created", user_id: user_id)
  end
end
