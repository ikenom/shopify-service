# frozen_string_literal: true

RSpec.describe ProductService, :vcr do
  let(:business_name) { Faker::Alphanumeric.alpha }
  let(:product_type) { Faker::Restaurant.type }
  let(:product_name) { Faker::Food.dish }
  let(:tags) { %w[test tag] }
  let(:price) { Faker::Commerce.price(range: 0..10.0, as_string: true) }

  let(:collection_id) { VendorService.new.create_collection(business_name: business_name) }
  let(:product_response) do
    client.create_product(business_name: business_name, product_type: product_type, collection_to_join: collection_id, product_name: product_name, tags: tags)
  end

  subject(:client) { ProductService.new }

  describe "#create_product" do
    it "should create product and return the collections Id" do
      response = product_response
      expect(response[:shopify_id]).to match(%r{(gid://shopify/Product/)+([0-9]*)})
      expect(response[:variant_id]).to match(%r{(gid://shopify/ProductVariant/)+([0-9]*)})
    end

    it "should update product name" do
      cached_response = product_response
      test_name = "testName"
      response = client.update_product(product_shopify_id: cached_response[:shopify_id], product_name: test_name, tags: nil)
      expect(response).to match(%r{(gid://shopify/Product/)+([0-9]*)})
    end

    it "should update products tags" do
      cached_response = product_response

      test_tags = ["tag1"]
      response = client.update_product(product_shopify_id: cached_response[:shopify_id], product_name: nil, tags: test_tags)
      expect(response).to be_present
      expect(response).to match(%r{(gid://shopify/Product/)+([0-9]*)})
    end

    it "should update product variant price" do
      cached_response = product_response
      response = client.update_product_price(product_variant_id: cached_response[:variant_id], price: price)

      expect(response).to be_present
      expect(response).to match(%r{(gid://shopify/ProductVariant/)+([0-9]*)})
    end

    it "should delete product from shopify" do
      cached_response = product_response

      response = client.delete(product_shopify_id: cached_response[:shopify_id])
      expect(response).to be_present
      expect(response).to match(%r{(gid://shopify/Product/)+([0-9]*)})
    end
  end
end
