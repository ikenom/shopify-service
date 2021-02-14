# frozen_string_literal: true

class Vendor
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :user_id, type: String
  field :shopify_id, type: String
  field :collection_id, type: String ## These collections need to be manual to avoid 5000 limit. https://community.shopify.com/c/Shopify-Discussion/Collection-Limit/td-p/242768

  # has_many :products

  index({ shopify_id: 1 }, { unique: true }) ## Need these so we don't do a whole table scan while we query. This will start to be a problem around 1-5k entries
  index({ user_id: 1 }, { unique: true })

  validates :user_id, :shopify_id, :collection_id, presence: true
end
