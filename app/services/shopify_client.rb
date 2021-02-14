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
      errorMessages = response.errors.messages.to_s
      raise QueryError, "Graphql Error Occured with messages #{errorMessages}." # TODO: create a data class for this error
    end

    response.original_hash["data"]
  end
end
