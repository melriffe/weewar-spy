require File.dirname(__FILE__) + '/test_helper'

class GoldSpy < WeewarSpy::Spy
  def initialize
    super(
      :server => 'server',
      :username => 'mriffe',
      :api_key => 'apiToken'
    )
  end
end

include XmlFixtures

class WeewarSpyOpenSlotTest < Test::Unit::TestCase
  
  context "Test #1: Amazon Game" do

    setup do
      WeewarSpy::API.expects(:get).with("/headquarters").returns(load_fixture('headquarters'))
      WeewarSpy::API.expects(:get).with("/user/mriffe").returns(load_fixture('mriffe'))
      @spy = GoldSpy.new
      WeewarSpy::API.expects(:get).with("/gamestate/128424").returns(load_fixture('128424-full'))
      @game = @spy.infiltrate(128424)
    end

    should "be infiltrated by a spy" do
      WeewarSpy::API.expects(:get).with("/user/madmike").returns(load_fixture('mriffe'))
      WeewarSpy::API.expects(:get).with("/user/jdub").returns(load_fixture('mriffe'))
      WeewarSpy::API.expects(:get).with("/user/mriffe").returns(load_fixture('mriffe'))
      puts @game.report
    end
    
  end
  
end
