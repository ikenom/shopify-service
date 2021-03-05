# frozen_string_literal: true

module Types
  class OrderType < Types::BaseObject
    field :id, ID, null: false
    field :price, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :line_items, [LineItemType], null: false
    field :customer, CustomerType, null: false
  end
end
