module Gemtastic
  class Source
    attr_reader :source

    def initialize source
      @source = source
    end

    def to_s
      "source '#{source}'"
    end

    def self.from_s string
      unless source_string? string
        raise Exception.new("Bad string passed - not source format")
      end
      source = /"([^"]+)"/.match(string.gsub("'", '"'))[1]
      self.new source
    end

    def self.source_string? string
      !!(string =~ /\Asource/)
    end
  end
end
