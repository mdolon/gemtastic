module Gemtastic
  class Gem
    attr_reader :gem, :params

    def initialize gem, params=nil
      @gem    = gem
      @params = params.empty? ? nil : params
    end

    def annotate
      Annotation.new(gem).to_s
    end

    def to_s
      [
        annotate,
        ["gem '#{gem}'", params].compact.join("")
      ].join("\n")
    end

    def self.from_s string
      unless gem_string? string
        raise Exception.new("Bad string passed - not gem format")
      end

      gem, match, params = string.partition(/(\Z|,| #)/)
      gem = /"([^"]+)"/.match(gem.gsub("'", '"'))[1]
      params = "#{match}#{params}"
      self.new gem, params
    end

    def self.gem_string? string
      !!(string =~ /\Agem/)
    end
  end
end
