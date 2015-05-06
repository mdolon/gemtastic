require 'spec_helper'
def gemfile_string
  <<-EOL
source 'https://rubygems.org'

## This is a comment and should stay in the file
# This is another comment

# The bundler gem - my own comment
gem 'bundler'

gem 'rspec' # Rspec gem

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
        expect(gemfile.to_s).to eq <<-EOL.chomp
source 'https://rubygems.org'

## This is a comment and should stay in the file
# This is another comment

# The bundler gem - my own comment
# Gemtastic isnt it??! #
gem 'bundler'

# Gemtastic isnt it??! #
gem 'rspec'

# Gemtastic isnt it??! #
gem 'rails', require: 'rails', branch: 'develop' # With options
        EOL
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
        expect(Gem.from_s(good_string).to_s).to eq <<-EOL.chomp
# Gemtastic isnt it??! #
gem 'gemmy', extra: blat
        EOL
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
