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
      @units.inject(0) {|sum, u| sum + u.strength}
    end
    
    def salary
      base_count * @game.credits_per_base
    end
    
    def base_count
      @terrains.select {|t| t.generates_income?}.size
    end
    
    def basic_info
      "#{(current? ? '*' : ' ')} Name: #{name}; Current: #{current}; State: #{state}; Result: #{result}"
    end
    
    def troop_info
      "Troop Strength: #{troop_strength}; Total Units: #{units.size}"
    end
    
    def terrain_info
      "Bases: #{base_count}; Total Terrains: #{terrains.size}"
    end
    
    def salary_info
      "Income: #{salary}"
    end
    
  end
end
