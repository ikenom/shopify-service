# frozen_string_literal: true

RSpec.describe VendorService, :vcr do
  let(:business_name) { "Vendor 1.0" }

  subject(:client) { VendorService.new }

  describe "#create_collection" do
    it "should create collection and return the collections Id" do
      response = client.create_collection(business_name: business_name)
      expect(response).to be_present
      expect(response).to match(%r{(gid://shopify/Collection/)+([0-9]*)})
    end
  end
end
