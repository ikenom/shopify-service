# frozen_string_literal: true

class ProductService
  include ShopifyClient

  ## We are currently enforcing that a product can only belong to a single collection
  CREATE_PRODUCT_QUERY = ShopifyAPI::GraphQL.client.parse <<-'GRAPHQL'
    mutation($business_name: String!, $tags: [String!], $product_type: String, $collection_to_join: ID!, $product_name: String!) {
      productCreate(
        input: {
          vendor: $business_name,
          title: $product_name,
          tags: $tags,
          productType: $product_type,
          collectionsToJoin: [$collection_to_join]
        }) {
              product {
                id
                title
                tags
                createdAt
                variants(first: 1) {
                  edges {
                    node {
                      id
                    }
                  }
                }
              }
              userErrors {
                field
                message
              }
        }
    }
  GRAPHQL

  UPDATE_PRODUCT_VARIANT_QUERY = ShopifyAPI::GraphQL.client.parse <<-'GRAPHQL'
  mutation($id: ID!, $price: Money) {
    productVariantUpdate(input: {id: $id, price: $price}) {
      productVariant {
        id
        price
      }
    }
  }
  GRAPHQL

  DeleteShopifyProductQuery = ShopifyAPI::GraphQL.client.parse <<-'GRAPHQL'
    mutation($id: ID!) {
      productDelete(
        input: { id: $id})
        {
          deletedProductId
          userErrors {
            field
            message
          }
        }
    }
  GRAPHQL

  def create_product(business_name:, product_type:, collection_to_join:, product_name:, tags:)
    result = shopify_query(CREATE_PRODUCT_QUERY, {
                             business_name: business_name,
                             product_type: product_type,
                             collection_to_join: collection_to_join,
                             product_name: product_name,
                             tags: tags
                           })

    product_node = result["productCreate"]["product"]
    product_variants = product_node["variants"]["edges"]

    {
      shopify_id: product_node["id"],
      variant_id: product_variants.first["node"]["id"]
    }
  end

  def update_product_price(product_variant_id:, price:)
    result = shopify_query(UPDATE_PRODUCT_VARIANT_QUERY, {
                             id: product_variant_id,
                             price: price
                           })

    result["productVariantUpdate"]["productVariant"]["id"]
  end
end
