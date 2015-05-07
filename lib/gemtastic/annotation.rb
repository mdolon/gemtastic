require 'net/http'
require 'json'

module Gemtastic
  class Annotation
    attr_reader :gem, :indent, :annotations

    API = 'https://rubygems.org/api/v1/gems/'

    def initialize gem, indent=nil, annotations=nil
      @gem = gem
      @indent = indent
      @annotations = annotations || {
        'homepage_uri' => 'Homepage',
        'source_code_uri' => 'Source',
        'documentation_uri' => 'Documentation'
      }
    end

    def to_s
      <<-EOL.chomp
#{indent}#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~
#{indent}#~#
#{indent}#~#   #{get['name']}:
#{indent}#~#   #{"-" * get['name'].length}
#{indent}#~#
#{indent}#~# #{get['info'].gsub(/\n/, "\n#{indent}#~#  ")}
#{indent}#~#
#{annotate}
#{indent}#~#
#{indent}#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~
#{indent}#~#
      EOL
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

    def annotate
      annotations.each_pair.map { |uri, header|
        "#{indent}#~# #{'%-14s' % (header<<':')} #{get[uri]}"
      }.join("\n")
    end
  end
end
