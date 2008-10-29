require 'rubygems'
require 'xmlsimple'

_DIR = File.expand_path( File.dirname( __FILE__ ) )

require "#{_DIR}/weewar-spy/__dir__"
require "#{__DIR__}/weewar-spy/version"
require "#{__DIR__}/weewar-spy/traits"
require "#{__DIR__}/weewar-spy/hex"
require "#{__DIR__}/weewar-spy/terrain"
require "#{__DIR__}/weewar-spy/unit"
require "#{__DIR__}/weewar-spy/faction"
require "#{__DIR__}/weewar-spy/game"
require "#{__DIR__}/weewar-spy/user"
require "#{__DIR__}/weewar-spy/api"
require "#{__DIR__}/weewar-spy/spy"

module WeewarSpy
  class << self
    def version
      WeewarSpy::VERSION
    end
  end
end