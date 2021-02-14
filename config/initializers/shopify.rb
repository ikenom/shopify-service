# frozen_string_literal: true

ShopifyAPI::Base.site = "https://#{ENV['API_KEY']}:#{ENV['API_PASSWORD']}@#{ENV['SHOP_NAME']}.myshopify.com"
ShopifyAPI::Base.api_version = "2021-01" # find the latest stable api_version here: https://shopify.dev/concepts/about-apis/versioning
