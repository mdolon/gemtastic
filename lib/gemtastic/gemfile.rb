module Gemtastic
  class Gemfile
    attr_reader :content

    def initialize gemfile_string, formatter
      @original_string = gemfile_string
      @content = parse_gemfile

      Gemtastic.const_set(:FORMATTER, formatter) unless defined? Gemtastic::FORMATTER
    end

    # Return an array of the parsed file content
    def parse_gemfile
      @original_string.split("\n").reject do |row|
        Annotation.source_string? row
      end.map do |row|
        if Gem.gem_string? row
          Gem.from_s row
        elsif Source.source_string? row
          Source.from_s row
        else
          row
        end
      end
    end

    def to_s
      @content.map(&:to_s).join("\n")
    end
  end
end
