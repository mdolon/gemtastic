require 'net/http'
require 'json'

module Gemtastic
  class Annotation
    attr_reader :gem

    API = 'https://rubygems.org/api/v1/gems/'

    def initialize gem
      @gem = gem
    end

    def to_s
      <<-EOL.chomp
################################################################################
# Name:          #{get['name']}
# Description:   #{get['info']}
# Homepage:      #{get['homepage_uri']}
# Source:        #{get['source_code_uri']}
# Documentation: #{get['documentation_uri']}
################################################################################
      EOL
    end

    def get
      @gem_info ||= JSON.parse(
        Net::HTTP.get(
          URI.parse(gem_api_url)
        )
      )
    end

    def gem_api_url
      "#{API}/#{gem}.json"
    end
  end
end
