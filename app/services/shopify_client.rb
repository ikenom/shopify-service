# frozen_string_literal: true

module ShopifyClient
  class QueryError < StandardError; end

  def shopify_client
    @shopify_client ||= ShopifyAPI::GraphQL.client
  end

  def shopify_query(definition, variables = {})
    response = ShopifyAPI::GraphQL.client.query(definition, variables: variables)

    ## Graphql query errors
    if response.errors.any?
      raise QueryError, "Graphql Error Occured with messages #{response.errors.messages}."
    end

    response.original_hash["data"]
  end
end
