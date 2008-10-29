#!/usr/bin/env ruby
$: << File.dirname(__FILE__) + "/../lib"

require 'rubygems'
require 'weewar-spy'

class WhiteSpy < WeewarSpy::Spy
  def initialize
    super(
      :server => 'weewar.com',
      :username => '???',  # change this to your username
      :api_key => '---'  # change this to your API key
    )
  end
end

begin
  
  spy = WhiteSpy.new
  spy.director.games.each do |game_info|
    spy.debrief(spy.infiltrate(game_info[0]))
  end
  
rescue Exception => e
  $stderr.puts "#{e.class}: #{e.message}"
  $stderr.puts e.backtrace.join( "\n\t" )
end
