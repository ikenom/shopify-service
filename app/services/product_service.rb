# frozen_string_literal: true

class ProductService
  CreateProductQuery = ShopifyAPI::GraphQL.client.parse <<-'GRAPHQL'
    mutation($vendor: String!, $tags: [String!], $productType: String, $collectionToJoin: ID!, $title: String!) {
      productCreate(
        input: {
          vendor: $vendor,
          title: $title,
          tags: $tags,
          productType: $productType,
          collectionsToJoin: [$collectionToJoin]
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
                      displayName
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

  UpdateProductVariantQuery = ShopifyAPI::GraphQL.client.parse <<-'GRAPHQL'
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

  def createProduct(productCreateInput); end
end
