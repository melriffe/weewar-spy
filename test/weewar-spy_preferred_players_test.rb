require File.dirname(__FILE__) + '/test_helper'

class OrangeSpy < WeewarSpy::Spy
  def initialize
    super(
      :server => 'server',
      :username => 'mriffe',
      :api_key => 'apiToken'
    )
  end
end

include XmlFixtures

class WeewarSpyPreferredPlayersTest < Test::Unit::TestCase
  
  context "Users with preferred players" do
    
    setup do
      WeewarSpy::API.expects(:get).with("/headquarters").returns(load_fixture('headquarters'))
      WeewarSpy::API.expects(:get).with("/user/mriffe").returns(load_fixture('mriffe'))
      @spy = OrangeSpy.new
    end
    
    should "work with single preferred" do
      WeewarSpy::API.expects(:get).with("/user/Adriel").returns(load_fixture('Adriel'))
      user = @spy.shadow('Adriel')
      assert_equal(1448, user.points)
      assert_equal(1, user.preferred_players.size)
    end
    
    should "work with multiple preferred" do
      WeewarSpy::API.expects(:get).with("/user/ceoduff").returns(load_fixture('ceoduff'))
      user = @spy.shadow('ceoduff')
      assert_equal(1685, user.points)
      assert_equal(12, user.preferred_players.size)
    end
    
  end
  
end
