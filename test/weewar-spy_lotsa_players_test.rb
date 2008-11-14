require File.dirname(__FILE__) + '/test_helper'

class BlueSpy < WeewarSpy::Spy
  def initialize
    super(
      :server => 'server',
      :username => 'mriffe',
      :api_key => 'apiToken'
    )
  end
end

include XmlFixtures

class WeewarSpyLotsaPlayersTest < Test::Unit::TestCase
  
  context "Lotsa Players Game" do

    setup do
      WeewarSpy::API.expects(:get).with("/headquarters").returns(load_fixture('headquarters'))
      WeewarSpy::API.expects(:get).with("/user/mriffe").returns(load_fixture('mriffe'))
      @spy = BlueSpy.new
      WeewarSpy::API.expects(:get).with("/gamestate/104121").returns(load_fixture('104121-full'))
      @game = @spy.infiltrate(104121)
    end

    should "be infiltrated by a spy" do
      WeewarSpy::API.expects(:get).with("/user/ceoduff").returns(load_fixture('ceoduff'))
      WeewarSpy::API.expects(:get).with("/user/mriffe").returns(load_fixture('mriffe'))
      WeewarSpy::API.expects(:get).with("/user/ntalbott").returns(load_fixture('mriffe'))
      WeewarSpy::API.expects(:get).with("/user/pelargir").returns(load_fixture('mriffe'))
      WeewarSpy::API.expects(:get).with("/user/jlong").returns(load_fixture('mriffe'))
      puts @game.basic_info
      @game.players.each do |player|
        puts player.basic_info
        puts player.troop_info
        puts player.extended_troop_info
        puts player.terrain_info
        puts player.extended_terrain_info
        puts player.salary_info
      end
      
    end
    
  end
    
end
