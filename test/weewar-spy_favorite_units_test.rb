require File.dirname(__FILE__) + '/test_helper'

class YellowSpy < WeewarSpy::Spy
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
      @spy = YellowSpy.new
    end
    
    should "work with single favorite" do
      WeewarSpy::API.expects(:get).with("/user/January11").returns(load_fixture('January11'))
      user = @spy.shadow('January11')
      assert_equal(1500, user.points)
      assert_equal(1, user.preferred_players.size)
    end
    
    should "work with multiple favorite" do
      WeewarSpy::API.expects(:get).with("/user/ceoduff").returns(load_fixture('ceoduff'))
      user = @spy.shadow('ceoduff')
      assert_equal(1685, user.points)
      assert_equal(12, user.preferred_players.size)
    end
    
  end
  
end
