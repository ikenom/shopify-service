# frozen_string_literal: true

class UrlMatchers
  # Returns URL without site.
  #
  # @param [String] url URL to parse.
  # @return [String] URL without site.
  def self.without_site(url)
    uri = Addressable::URI.parse(url)
    uri.to_s.delete_prefix(uri.site)
  end

  # Matches two URLs while ignoring sites.
  #
  # @param [String] url_a First URL to parse.
  # @param [String] url_b Second URL to parse.
  # @return [TrueClass] The provided URLs match.
  # @return [FalseClass] The provided URLs do not match.
  def self.match_without_site?(url_a, url_b)
    without_site(url_a) == without_site(url_b)
  end
end
