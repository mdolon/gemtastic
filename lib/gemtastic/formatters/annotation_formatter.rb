module Gemtastic
  class AnnotationFormatter
    def initialize annotation, annotations = nil
      @annotation = annotation
      @annotations = annotations || {
        "homepage_uri" => "Homepage",
        "source_code_uri" => "Source",
        "documentation_uri" => "Documentation"
      }
    end

    def to_s
      to_s_lines.map { |line| "#{indent}#{line}" }.join("\n")
    end

    private

    attr_reader :annotation, :annotations

    def to_s_lines
      [
        header,
        name,
        underline,
        spacer,
        description,
        spacer,
        annotate,
        spacer,
        header,
        spacer
      ].flatten
    end

    def spacer
      "#~#"
    end

    def header
      "#~" * 40
    end

    def description
      "#{spacer} #{annotation.get["info"].gsub(/\n/, "\n#{indent}#{spacer} ")}"
    end

    def name
      "#{spacer}   #{annotation.get["name"]}"
    end

    def underline
      "#{spacer}   " + ("-" * annotation.get["name"].length)
    end

    def annotate
      annotations.each_pair.map { |uri, header|
        "#{spacer} #{"%-14s" % (header << ":")} #{annotation.get[uri]}"
      }
    end

    def indent
      annotation.indent
    end
  end
end
