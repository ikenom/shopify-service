# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :orders, Types::OrderType.connection_type, null: false do
      description "Find a post by ID"
      argument :vendor_id, ID, required: true
    end

    def orders(_vendor_id)
      orders = OrderService.new.order
      orders["orders"]["edges"].map do |edge|
        {
          id: edge["node"]["id"],
          created_at: edge["node"]["createdAt"],
          price: edge["node"]["totalPriceSet"]["presentmentMoney"]["amount"],
          line_items: edge["node"]["lineItems"]["edges"].map do |li_edge|
            {
              id: li_edge["node"]["id"]
            }
          end,
          customer: {
            first_name: edge["node"]["customer"]["firstName"],
            last_name: edge["node"]["customer"]["lastName"]
          }
        }
      end
    end
  end
end
