require 'net/http'
require 'json'

module Gemtastic
  class Annotation
    attr_reader :gem, :indent, :annotations

    API = 'https://rubygems.org/api/v1/gems/'

    def initialize gem, indent=nil
      @gem = gem
      @indent = indent
    end

    def to_s formatter=AnnotationFormatter
      formatter.new(self).to_s
    end

    def get
      return @gem_info if @gem_info
      @gem_info = JSON.parse(
        Net::HTTP.get(
          URI.parse(gem_api_url)
        )
      )
    end

    def gem_api_url
      "#{API}/#{gem}.json"
    end

    def self.source_string? str
      /\A#~#/.match str
    end
  end
end
