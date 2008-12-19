module WeewarSpy
  class Faction
    attr_reader :name, :current, :result, :state, :credits
    attr_reader :units, :terrains, :game
    
    def initialize(player, game)
      @game = game
      @name = player
      @current = false
      @result = ''
      @state = ''
      if player.is_a? Hash
        @name = player['content']
        @current = (player['current'] == 'true')
        @result = player['result']
      end
      @units = []
      @terrains = []
      @state = ''
      @credits = 0
    end
    
    def faction(xml)
      @result = xml['result']
      @state = xml['state']
      @credits = (xml['credits'].nil? ? 0 : xml['credits'].to_i)
      
      unless xml['unit'].nil?
        xml[ 'unit' ].each do |u|
          @units << WeewarSpy::Unit.new(u)
        end
      end
      
      unless xml['terrain'].nil?
        xml[ 'terrain' ].each do |t|
          @terrains << WeewarSpy::Terrain.new(t)
        end
      end
    end
    
    def user
      @user ||= WeewarSpy::User.new(@name)
    end
    
    def current?
      @current
    end
    
    def surrendered?
      "surrendered" == @result
    end
    
    def abandoned?
      "abandoned" == @result
    end
    
    def active?
      "playing" == @state
    end
    
    def troop_strength
      Unit.troop_strength(@units)
    end
    
    def salary
      base_count * @game.credits_per_base
    end
    
    def base_count
      Terrain.base_count(@terrains)
    end
    
    def report
      # FIXME: Report Generation
      report = "--------------------\n"
      report += "#{(current? ? '*' : (active? ? ' ' : 'x'))} Name: #{name}"
      unless result.nil?
        report += "; State: #{state}; Result: #{result}\n"
      else
        report += "; Points: #{user.points}; On: #{user.on}\n"
        report += "  Income: #{salary}\n"
        report += Unit.report_for(@units)
        report += Terrain.report_for(@terrains)
      end
      report
    end
    
  end
end
