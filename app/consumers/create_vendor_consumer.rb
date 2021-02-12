class CreateVendorConsumer
  include Hutch::Consumer
  consume "shopify.vendor.create"

  def process(message)
    CreateVendorJob.perform_later(
      user_id: message[:user_id], 
      business_name: message[:business_name], 
      first_name: message[:first_name], 
      last_name: message[:last_name], 
      email: message[:email], 
      phone: message[:phone])
  end
end