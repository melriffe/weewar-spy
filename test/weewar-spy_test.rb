require File.dirname(__FILE__) + '/test_helper'

class BlackSpy < WeewarSpy::Spy
  def initialize
    super(
      :server => 'server',
      :username => 'mriffe',
      :api_key => 'apiToken'
    )
  end
end

include XmlFixtures

class WeewarSpyTest < Test::Unit::TestCase
  
  context "Weewar Spy Auxillary" do

    should "have a non-nil version" do
      assert_not_nil(WeewarSpy.version)
    end

    should "return same value as VERSION" do
      assert_equal(WeewarSpy::VERSION, WeewarSpy.version)
    end
    
  end
  
  context "Weewar Spy Basic" do
    
    setup do
      WeewarSpy::API.expects(:get).with("/headquarters").returns(load_fixture('headquarters'))
      WeewarSpy::API.expects(:get).with("/user/mriffe").returns(load_fixture('mriffe'))
      @spy = BlackSpy.new
    end
    
    should "get spy diretor" do
      assert_not_nil(@spy.director)
    end
    
    should "return configured username" do
      assert_equal('mriffe', @spy.username)
    end
    
    context "as the director" do
      
      setup do
        @director = @spy.director
      end
      
      should "list games" do
        games = @director.games
        assert_same_elements([104121, 112237, 113972], games.keys)
        assert_same_elements(["Lotsa Players", "1v1v1v1", "super"], games.values)
      end

    end
    
    should "shadow a user" do
      WeewarSpy::API.expects(:get).with("/user/ceoduff").returns(load_fixture('ceoduff'))
      user = @spy.shadow('ceoduff')
      assert_equal(1685, user.points)
    end
    
    should "reconnoiter a game" do
      WeewarSpy::API.expects(:get).with("/game/104121").returns(load_fixture('104121'))
      game = @spy.reconnoiter(104121)
      assert_not_nil(game.current_player)
      assert_equal('ceoduff', game.current_player.name)
      assert_equal(6, game.players.size)
      assert_equal(1, game.surrendered_players.size)
      assert_equal(0, game.abandoned_players.size)
    end
    
  end
  
  context "Weewar Spy Advanced" do
    
    setup do
      WeewarSpy::API.expects(:get).with("/headquarters").returns(load_fixture('headquarters'))
      WeewarSpy::API.expects(:get).with("/user/mriffe").returns(load_fixture('mriffe'))
      @spy = BlackSpy.new
    end

    context "infiltrate a game" do
      
      setup do
        WeewarSpy::API.expects(:get).with("/gamestate/104121").returns(load_fixture('104121-full'))
        @game = @spy.infiltrate(104121)
      end
      
      should "have a current player" do
        assert_not_nil(@game.current_player)
        assert_equal('ceoduff', @game.current_player.name)
      end
      
      should "calculate a player's troop strength" do
        assert_equal(6, @game.players.size)
        assert_equal(@game.players, @game.factions)
        assert_equal(237, @game.current_player.troop_strength)
      end

      should "calculate a player's salary" do
        assert_equal(100, @game.credits_per_base)
        assert_equal(2000, @game.current_player.salary)
      end
      
    end
    
  end
  
end
