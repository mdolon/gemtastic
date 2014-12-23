# require "gemtastic/version"
require 'rubygems'
require 'bundler'
require 'fileutils'
require 'gemnasium/parser'
require 'pry'
require 'tempfile'
require 'open-uri'
require 'json'

class Gemtastic
  def initialize
    process("Gemfile.test")
  end

  def process(gemfile)
    # Assign gemfile path relative to location of execution
    local_gemfile = File.dirname(__FILE__) + "/../Gemfile.test"

    # Exit if file doesn't exist
    abort("Could not find the file, exiting") unless File.file?(local_gemfile)

    # Create new empty array, we'll store the list of gems here
    gemlist ||= []

    # Load the gems in the gemfile, stash each gem and it's version
    gemfile = Gemnasium::Parser::Gemfile.new(File.open(local_gemfile).read)
    gemfile.dependencies.each_with_index.map {|x, i| gemlist << [x.name, x.requirement.as_list, x.groups]}

    # Sort by groups and group by uniques
    # gemlist = gemlist.sort_by {|gem| gem[2].to_s }.group_by {|gem| gem[2].uniq}

    # Fetch gem info from API server
    query = gemlist.map{|x| x[0]}.join(',')
    @gemdict = JSON.load(open("http://0.0.0.0:3000/gems/#{query}"))

    # iterate through server and fill in gem info
    temp_file = Tempfile.new(File.dirname(__FILE__) + "Gemfile.test.tmp")
    File.open(local_gemfile, 'r') do |f|
      f.each_line do |line|
        line = line.gsub("\t", '  ')
        temp_file.puts line.include?("gem") ? gem_comment(line) : line
      end
    end
    temp_file.close
    FileUtils.mv(temp_file.path, local_gemfile)

  end

  def gem_comment(line)
    comment = "\n"

    # Add prerequisite tabs
    tab_spaces = ""
    line[/\A */].size.times { tab_spaces += " " }

    gemline = Gemnasium::Parser::Gemfile.new(line)

    if gemline.dependencies.length > 0
      geminfo = @gemdict.find {|gem| gem["name"] == gemline.dependencies.first.name }

      if geminfo
        comment += "#{tab_spaces}# #{geminfo['info']}\n" if geminfo.has_key?("info")
        return comment+line
      else
        return line
      end
    else
      return line
    end
  end

  # def process_old(gemfile)
  #   # Assign gemfile path relative to location of execution
  #   local_gemfile = File.dirname(__FILE__) + "/../Gemfile.test"

  #   # Exit if file doesn't exist
  #   abort("Could not find the file, exiting") unless File.file?(local_gemfile)

  #   # Create new empty array, we'll store the list of gems here
  #   gemlist ||= []

  #   # Load the gems in the gemfile, stash each gem and it's version
  #   gemfile = Gemnasium::Parser::Gemfile.new(File.open(local_gemfile).read)
  #   gemfile.dependencies.each_with_index.map {|x, i| gemlist << [x.name, x.requirement.as_list, x.groups]}

  #   # Sort by groups and group by uniques
  #   gemlist = gemlist.sort_by {|gem| gem[2].to_s }.group_by {|gem| gem[2].uniq}

  #   # TODO: Fetch gem info from API server

  #   # Find the source(s)
  #   source = ""
  #   File.open(local_gemfile, 'r') do |f|
  #     f.each_line do |line|
  #       if line.include?("source")
  #         source += line
  #       end
  #     end
  #   end

  #   temp_file = Tempfile.new(File.dirname(__FILE__) + "Gemfile.test.tmp")
  #   temp_file.puts source

  #   gemlist.each do |group, value|
  #     unless group.include?(:default)
  #       group_names = group.map{|x| ":"+x.to_s}.join(',')
  #       puts "group #{group_names} do\n"
  #     end
  #   end

  #   # temp_file.close
  #   # FileUtils.mv(temp_file.path, local_gemfile)
    
  #   # File.open(local_gemfile, "w+") do |file|
  #   #   file.each_line do |line|
  #   #     file.puts "#comment here\n" + line
  #   #   end
  #   # end

  # end
end

Gemtastic.new
