# frozen_string_literal: true

class Product
  include Mongoid::Document

  field :shopify_id, type: String
  field :variant_id, type: String # Price of a product and tax code info is associated with its variant
  field :price, type: String
  field :name, type: String
  field :type, type: String

  belongs_to :vendor

  index({ shopify_id: 1 }, { unique: true }) ## Need these so we don't do a whole table scan while we query. This will start to be a problem around 1-5k entries

  validates :shopify_id, :variant_id, :price, :name, :type, presence: true
end
