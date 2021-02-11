require 'shopify_api'
require "active_support/concern"

module ShopifyClient
  extend ActiveSupport::Concern

  class QueryError < StandardError; end

  ### Graphql Queries ###

  CreateShopifyCustomerQuery = ShopifyAPI::GraphQL.client.parse <<-'GRAPHQL'
    mutation($email: String!, $firstName: String!, $lastName: String, $phone: String, $tags: [String!]) {
        customerCreate(
          input: {
            email: $email,
            firstName: $firstName,
            lastName: $lastName,
            phone: $phone,
            tags: $tags
          }) {
              customer {
                id
                firstName
                lastName
                email
                phone
              }
              userErrors {
                field
                message
              }
          }
      }
  GRAPHQL

  UpdateShopifyCustomerQuery = ShopifyAPI::GraphQL.client.parse <<-'GRAPHQL'
    mutation($id: ID!, $email: String, $firstName: String, $lastName: String, $phone: String, $tags: [String!]) {
      customerUpdate(
        input: {
          id: $id
          email: $email,
          firstName: $firstName,
          lastName: $lastName,
          phone: $phone,
          tags: $tags
        }) {
            customer {
              id
              firstName
              lastName
              email
              phone
            }
            userErrors {
              field
              message
            }
        }
    }
  GRAPHQL

  DeleteShopifyCustomerQuery = ShopifyAPI::GraphQL.client.parse <<-'GRAPHQL'
    mutation($id: ID!) {
      customerDelete(
        input: { id: $id}) 
        {
          deletedCustomerId
          userErrors {
            field
            message
          }
        }
    }
  GRAPHQL

  included do
    private

    def shopify_client
      @shopify_client ||= ShopifyAPI::GraphQL.client
    end

    def shopify_query(definition, variables = {})
      byebug
      response = ShopifyAPI::GraphQL.client.query(definition, variables: variables)

      ## Graphql query errors
      if response.errors.any?
        errorMessages = response.errors.messages.to_s
        raise QueryError.new("Graphql Error Occured with messages #{errorMessages}.") # TODO create a data class for this error
      end

      data = response.original_hash["data"]

      if data["customerCreate"] && data["customerCreate"]["userErrors"].any?
        raise StandardError.new("Failed to create shopify customer: #{data["customerCreate"]["userErrors"]}")
      end

      return data
    end
    
  end
end