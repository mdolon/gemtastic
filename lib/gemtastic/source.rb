module Gemtastic
  class Source
    attr_reader :source

    def initialize(source)
      @source = source
    end

    def to_s
      "source '#{source}'"
    end

    def self.from_s(string)
      unless source_string? string
        raise StandardError.new("Bad string passed - not source format")
      end
      source = /"([^"]+)"/.match(string.tr("'", '"'))[1]
      new source
    end

    def self.source_string?(string)
      !!string.start_with?("source")
    end
  end
end
