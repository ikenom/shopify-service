# frozen_string_literal: true

RSpec.describe ProductService, :vcr do
  let(:business_name) { "Vendor 1.0" }
  let(:product_type) { "Meal" }
  let(:collection_to_join) { "gid://shopify/Collection/244474642629" } ## Need to get a real one
  let(:product_name) { "Product One" }
  let(:tags) { %w[test tag] }

  let(:product_variant_id) { "gid://shopify/ProductVariant/38122440982725" }
  let(:price) { "4.20" }

  subject(:client) { ProductService.new }

  describe "#create_product" do
    it "should create product and return the collections Id" do
      response = client.create_product(business_name: business_name, product_type: product_type, collection_to_join: collection_to_join, product_name: product_name, tags: tags)
      expect(response).to be_present
      expect(response[:shopify_id]).to match(%r{(gid://shopify/Product/)+([0-9]*)})
      expect(response[:variant_id]).to match(%r{(gid://shopify/ProductVariant/)+([0-9]*)})
    end

    it "should update product and give it a price" do
      response = client.update_product_price(product_variant_id: product_variant_id, price: price)

      expect(response).to be_present
      expect(response).to match(%r{(gid://shopify/ProductVariant/)+([0-9]*)})
    end
  end
end
