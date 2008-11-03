require File.dirname(__FILE__) + '/test_helper'

class GreenSpy < WeewarSpy::Spy
  def initialize
    super(
      :server => 'server',
      :username => 'mriffe',
      :api_key => 'apiToken'
    )
  end
end

include XmlFixtures

class WeewarSpySuperTest < Test::Unit::TestCase
  
  context "super Game" do

    setup do
      WeewarSpy::API.expects(:get).with("/headquarters").returns(load_fixture('headquarters'))
      WeewarSpy::API.expects(:get).with("/user/mriffe").returns(load_fixture('mriffe'))
      @spy = GreenSpy.new
      WeewarSpy::API.expects(:get).with("/gamestate/113972").returns(load_fixture('113972-full'))
      @game = @spy.infiltrate(113972)
    end

    should "be infiltrated by a spy" do
      WeewarSpy::API.expects(:get).with("/user/phsequeira").returns(load_fixture('mriffe'))
      WeewarSpy::API.expects(:get).with("/user/ohnoanotherputz").returns(load_fixture('mriffe'))
      WeewarSpy::API.expects(:get).with("/user/kidx").returns(load_fixture('mriffe'))
      WeewarSpy::API.expects(:get).with("/user/throttle").returns(load_fixture('mriffe'))
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
