module Gemtastic
  require 'gemtastic/version'
  require 'gemtastic/annotation'
  require 'gemtastic/gem'
  require 'gemtastic/gemfile'
  require 'gemtastic/source'

  require 'gemtastic/formatters/annotation_formatter.rb'
  require 'gemtastic/formatters/colorized_annotation_formatter.rb'

  def self.ate opts
    formatter = opts[:color] ? Gemtastic::ColorizedAnnotationFormatter
              :                Gemtastic::AnnotationFormatter

    Gemfile.new File.read(opts.arguments.first)
  end
end
