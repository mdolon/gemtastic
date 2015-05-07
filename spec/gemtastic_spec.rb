require 'spec_helper'
def gemfile_string
  <<-EOL.chomp
source 'https://rubygems.org'

## This is a comment and should stay in the file
# This is another comment

# The bundler gem - my own comment
gem 'bundler'

gem 'rspec' # Rspec gem

gem 'rails', require: 'rails', branch: 'develop' # With options
  EOL
end

def annotated_string
  <<-EOL.chomp
source 'https://rubygems.org'

## This is a comment and should stay in the file
# This is another comment

# The bundler gem - my own comment
################################################################################
# Name:          bundler
# Description:   Bundler manages an application's dependencies through its entire life, across many machines, systematically and repeatably
# Homepage:      http://bundler.io
# Source:        http://github.com/carlhuda/bundler/
# Documentation: http://gembundler.com
################################################################################
gem 'bundler'

################################################################################
# Name:          rspec
# Description:   BDD for Ruby
# Homepage:      http://github.com/rspec
# Source:        http://github.com/rspec/rspec
# Documentation: http://relishapp.com/rspec
################################################################################
gem 'rspec' # Rspec gem

################################################################################
# Name:          rails
# Description:   Ruby on Rails is a full-stack web framework optimized for programmer happiness and sustainable productivity. It encourages beautiful code by favoring convention over configuration.
# Homepage:      http://www.rubyonrails.org
# Source:        http://github.com/rails/rails
# Documentation: http://api.rubyonrails.org
################################################################################
gem 'rails', require: 'rails', branch: 'develop' # With options
  EOL
end

module Gemtastic
  describe VERSION do
    it "Should be a string with format x.x.x" do
      expect(VERSION).to match /\d+\.\d+\.\d+/
    end
  end

  describe Gemfile do
    let(:gemfile) { Gemfile.new gemfile_string }

    describe "#initialize" do
      it "should take a Gemfile content string to initialize" do
        expect(Gemfile.new(gemfile_string)).to be_an_instance_of Gemfile
      end
    end

    describe "#parse_gemfile" do
      let(:parse_gemfile) {
        gemfile.parse_gemfile
      }

      it "Should return an array" do
        expect(parse_gemfile).to be_an Array
      end

      it "Should have a Source object as the first element" do
        expect(parse_gemfile.first).to be_a Source
      end

      it "Should have a string object as the second object" do
        expect(parse_gemfile[1]).to eq ""
      end

      it "Should have a Gem object as the 7th object" do
        expect(parse_gemfile[6]).to be_a Gem
      end
    end

    describe "#to_s" do
      it "Should be correct!" do
        expect(gemfile.to_s).to eq annotated_string
      end
    end
  end

  describe Gem do
    let(:good_string) { "gem 'gemmy', extra: blat" }
    let(:bad_string)  { "xgem 'gemmy', extra: blat" }

    describe ".gem_string?" do
      it "should return true for: gem 'something'" do
        expect(Gem.gem_string?('gem: "something"')).to be true
      end

      it 'should return false for: xgem "something"' do
        expect(Gem.gem_string?('xgem: "something"')).to be false
      end
    end

    describe ".from_s" do
      it "should return a new Gem when given a good string" do
        expect(Gem.from_s good_string).to be_a Gem
      end

      it "should raise an exception when given a bad string" do
        expect{ Gem.from_s bad_string }.to raise_error
      end
    end

    describe "#to_s" do
      it "should be correct" do
        expect(Gem.from_s(good_string).to_s).to match /Provides custom thor/
      end
    end
  end

  describe Source do
    describe ".source_string?" do
      it "should return true for: source 'something'" do
        expect(Source.source_string?('source: "something"')).to be true
      end

      it 'should return false for: xsource "something"' do
        expect(Source.source_string?('xsource: "something"')).to be false
      end
    end

    describe ".from_s" do
      let(:good_string) { "source 'gemmy'" }
      let(:bad_string)  { "xsource 'gemmy'" }

      it "should return a new Source when given a good string" do
        expect(Source.from_s good_string).to be_a Source
      end

      it "should raise an exception when given a bad string" do
        expect{ Source.from_s bad_string }.to raise_error
      end
    end
  end

  describe Annotation do
    let(:annotation) { Annotation.new 'bundler' }

    describe "#gem_api_url" do
      it "should return the proper url" do
        expect(annotation.gem_api_url).to eq "#{Annotation::API}/bundler.json"
      end
    end

    describe "#get" do
      it "should return a hash object" do
        expect(annotation.get).to be_an_instance_of Hash
      end
    end

    describe "#to_s" do
      it "should have the proper fields" do
        expect(annotation.to_s).to eq <<-EOL.chomp
################################################################################
# Name:          bundler
# Description:   Bundler manages an application's dependencies through its entire life, across many machines, systematically and repeatably
# Homepage:      http://bundler.io
# Source:        http://github.com/carlhuda/bundler/
# Documentation: http://gembundler.com
################################################################################
        EOL
      end
    end
  end
end
  # let(:gemfile) { gemfile_string }
  # subject { Gemtastic.new(gemfile) }

  # describe '#process' do
  #   let(:input) { "source 'https://rubygems.org'\ngemspec" }
  #   let(:output) { ["source 'https://rubygems.org'", "gemspec"] }

  #   it 'stick gemfile into array' do
  #     expect(output.downcase).to eq output
  #   end

  #   # it 'combines nouns with doge adjectives' do
  #   #   expect(output).to match /so grandmom\./i
  #   #   expect(output).to match /such sweater\./i
  #   #   expect(output).to match /very christmas\./i
  #   # end

  #   # it 'always appends "wow."' do
  #   #   expect(output).to end_with 'wow.'
  #   # end
  # end
# end
