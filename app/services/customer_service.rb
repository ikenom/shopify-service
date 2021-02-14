# frozen_string_literal: true

class CustomerService
  include ShopifyClient

  class UserCreationError < RuntimeError; end

  CREATE_SHOPIFY_CUSTOMER_QUERY = ShopifyAPI::GraphQL.client.parse <<-'GRAPHQL'
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

  def create_customer(first_name:, last_name:, email:, phone:, tags:)
    result = shopify_query(CREATE_SHOPIFY_CUSTOMER_QUERY, {
                             "email" => email,
                             "firstName" => first_name,
                             "lastName" => last_name,
                             "phone" => phone,
                             "tags" => tags
                           })

    raise UserCreationError if result["customerCreate"] && result["customerCreate"]["userErrors"].any?

    result["customerCreate"]["customer"]["id"]
  end
end
