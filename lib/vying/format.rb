# Copyright 2007-08, Eric Idema except where otherwise noted.
# You may redistribute / modify this file under the same terms as Ruby.

require 'vying'

module Vying

  # Format.

  class Format

    # Scans the RUBYLIB (unless overridden via path), for format subclasses and
    # requires them.  Looks for files that match:
    #
    #   <Dir from path>/**/formats/*.rb
    #

    def self.require_all( path=$: )
      required = []
      path.each do |d|
        Dir.glob( "#{d}/**/formats/*.rb" ) do |f|
          f =~ /(.*)\/formats\/([\w\d]+\.rb)$/
          if ! required.include?( $2 ) && !f["_test"]
            required << $2
            require "#{f}"
          end
        end
      end
    end

    @@format_list = []

    # When a subclass extends Format, it is added to @@format_list.

    def self.inherited( child )
      @@format_list << child
    end

    # Get a list of all Format subclasses.

    def self.list
      @@format_list
    end

    # Find a specific Format by type

    def self.find( type )
      list.find { |f| f.type == type }
    end

  end

  def self.load( string, type )
    format = Format.find( type )

    raise "Couldn't find format for type #{type}"  unless format

    format.new.load( string )
  end

  def self.dump( game, type )
    format = Format.find( type )

    raise "Couldn't find format for type #{type}"  unless format

    format.new.dump( game )
  end
end

