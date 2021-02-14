# frozen_string_literal: true

class VendorService
  include ShopifyClient
  
  CREATE_VENDOR_COLLECTION_QUERY = ShopifyAPI::GraphQL.client.parse <<-'GRAPHQL'
  mutation($name: String!) {
      collectionCreate( input: {title: $name} ) {
        collection {
          id
          title
        }
        userErrors {
          field
          message
        }
    }
  }
  GRAPHQL

  def create_collection(business_name:)
    result = shopify_query(CREATE_VENDOR_COLLECTION_QUERY, { "name" => business_name })
    result["collectionCreate"]["collection"]["id"]
  end

end
