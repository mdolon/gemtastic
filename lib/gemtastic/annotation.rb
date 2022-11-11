require "net/http"
require "json"

module Gemtastic
  class Annotation
    attr_reader :gem, :indent, :annotations

    API = "https://rubygems.org/api/v1/gems/"

    def initialize(gem, indent = nil)
      @gem = gem
      @indent = indent
    end

    def to_s
      FORMATTER.new(self).to_s
    end

    def get
      gem_details_uri = "#{API}/#{gem}.json"
      @gem_info = URI.parse(gem_details_uri).then do |uri|
        Net::HTTP.get(uri).then do |response|
          JSON.parse(response)
        end
      end
    end

    def self.source_string?(str)
      /\A\s*#~#/.match(str)
    end
  end
end
