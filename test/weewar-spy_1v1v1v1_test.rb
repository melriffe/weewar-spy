require File.dirname(__FILE__) + '/test_helper'

class RedSpy < WeewarSpy::Spy
  def initialize
    super(
      :server => 'server',
      :username => 'mriffe',
      :api_key => 'apiToken'
    )
  end
end

include XmlFixtures

class WeewarSpy1v1v1v1Test < Test::Unit::TestCase
  
  context "1v1v1v1 Game" do

    setup do
      WeewarSpy::API.expects(:get).with("/headquarters").returns(load_fixture('headquarters'))
      WeewarSpy::API.expects(:get).with("/user/mriffe").returns(load_fixture('mriffe'))
      @spy = RedSpy.new
      WeewarSpy::API.expects(:get).with("/gamestate/112237").returns(load_fixture('112237-full'))
      @game = @spy.infiltrate(112237)
    end

    should "be infiltrated by a spy" do
      WeewarSpy::API.expects(:get).with("/user/Beeker").returns(load_fixture('mriffe'))
      WeewarSpy::API.expects(:get).with("/user/KaBloom").returns(load_fixture('mriffe'))
      WeewarSpy::API.expects(:get).with("/user/mriffe").returns(load_fixture('mriffe'))
      puts @game.basic_info
      @game.players.each do |player|
        puts player.basic_info
        puts player.troop_info
        puts player.terrain_info
        puts player.salary_info
      end
      
    end
    
  end
  
end
