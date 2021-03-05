# frozen_string_literal: true

class OrderService
  include ShopifyClient

  ORDER_QUERY = ShopifyAPI::GraphQL.client.parse <<-'GRAPHQL'
    {
      orders(first:10) {
        edges {
          node {
            id
            createdAt
            customer {
              firstName
              lastName
            }
            totalPriceSet {
              presentmentMoney {
                amount
                currencyCode
              }
            }
            lineItems(first:10) {
              edges {
                node {
                  id
                }
              }
            }
          }
        }
      }
    }
  GRAPHQL

  def order
    shopify_query(ORDER_QUERY)
  end
end
