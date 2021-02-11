class VendorService
include ShopifyClient

  CreateVendorCollectionQuery = ShopifyAPI::GraphQL.client.parse <<-'GRAPHQL'
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



  def createVendor(ecommerce_id:, buisnessName:, firstName:, lastName:, email:, phone:)
    begin
      raise "Cannot create vendor. Ecommerce Id \"#{ecommerce_id}\" is taken." if Vendor.where(ecommerce_id: ecommerce_id).exists?
      
      createVendorProfileData = {
        'email' => email,
        'firstName' => firstName,
        'lastName' => lastName,
        'phone' => phone,
        'tags' => "vendor"
      }

      shopifyCustomerCreationResult = shopify_query(ShopifyClient::CreateShopifyCustomerQuery, createVendorProfileData)
      shopifyCollectionCreateResult = shopify_query(CreateVendorCollectionQuery, {'name' => buisnessName})

      shopifyCustomerProfile = shopifyCustomerCreationResult["customerCreate"]["customer"]
      vendorCollectionId = shopifyCollectionCreateResult["collectionCreate"]["collection"]["id"]

      Vendor.create!({
        ecommerce_id: ecommerce_id,
        shopify_id: shopifyCustomerProfile["id"],
        collection_id: vendorCollectionId
      })
    rescue => exception
      # Remove shopify customer profile if one was created
      if !shopifyCustomerCreationResult.nil?
        shopifyClient.query(ShopifyClient::DeleteShopifyCustomerQuery, {'id' => shopifyCustomerProfile["id"]})
      end
      raise "Error during vendor creation. \n Incoming request: #{vendor}. \n Error: #{exception}"
    end

  end

  def updateVendor()
  end

end