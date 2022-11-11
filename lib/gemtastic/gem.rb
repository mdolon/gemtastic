module Gemtastic
  class Gem
    attr_reader :gem, :params, :prefix

    def initialize gem, prefix = nil, params = nil
      @gem = gem
      @prefix = prefix.empty? ? nil : prefix
      @params = params.empty? ? nil : params
    end

    def annotate
      Annotation.new(gem, prefix).to_s
    end

    def to_s
      [
        annotate,
        ["#{prefix}gem '#{gem}'", params].compact.join("")
      ].join("\n")
    end

    def self.from_s string
      unless gem_string? string
        raise StandardError.new("Bad string passed - not gem format")
      end

      matches = /\A(\s*)gem ['"]([^"']+)['"](.*)/.match string
      prefix, gem, params = matches[1..3]

      new gem, prefix, params
    end

    def self.gem_string? string
      !!(string =~ /\A\s*gem /)
    end
  end
end
