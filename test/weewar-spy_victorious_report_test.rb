require File.dirname(__FILE__) + '/test_helper'

class PurpleSpy < WeewarSpy::Spy
  def initialize
    super(
      :server => 'server',
      :username => 'mriffe',
      :api_key => 'apiToken'
    )
  end
end

include XmlFixtures

class WeewarSpyVictoriousReportTest < Test::Unit::TestCase
  
  context "how fast can you win?! Game" do

    setup do
      WeewarSpy::API.expects(:get).with("/headquarters").returns(load_fixture('headquarters'))
      WeewarSpy::API.expects(:get).with("/user/mriffe").returns(load_fixture('mriffe'))
      @spy = PurpleSpy.new
      WeewarSpy::API.expects(:get).with("/gamestate/124033").returns(load_fixture('124033-full'))
      @game = @spy.infiltrate(124033)
    end

    should "be infiltrated by a spy" do
      # WeewarSpy::API.expects(:get).with("/user/ai_SmileyBot").returns(load_fixture('mriffe'))
      # WeewarSpy::API.expects(:get).with("/user/mriffe").returns(load_fixture('mriffe'))
      puts @game.report
    end
    
  end
  
end
