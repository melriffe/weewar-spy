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
      @units.inject(0) {|sum, u| sum + u.strength}
    end
    
    def salary
      base_count * @game.credits_per_base
    end
    
    def base_count
      @terrains.select {|t| t.is_base?}.size
    end
    
    def basic_info
      info = "#{(current? ? '*' : ' ')} Name: #{name}"
      unless result.nil?
        info += "; State: #{state}; Result: #{result}"
      else
        info += "; Points: #{user.points}; On: #{user.on}"
      end
      info
    end
    
    def troop_info
      "Total Units: #{units.size}; Troop Strength: #{troop_strength}"
    end
    
    def extended_troop_info
      info = ""
      unless @units.empty?
        troops = @units.select {|u| u.is_infantry?}
        unless troops.empty?
          info += "\tInfantry => Units: #{troops.size}; Strength: #{troops.inject(0) {|sum, u| sum + u.strength}}"
        end
        troops = @units.select {|u| u.is_vehicle?}
        unless troops.empty?
          info += "\n" unless info.empty?
          info += "\tVehicles => Units: #{troops.size}; Strength: #{troops.inject(0) {|sum, u| sum + u.strength}}"
        end
        troops = @units.select {|u| u.is_aircraft?}
        unless troops.empty?
          info += "\n" unless info.empty?
          info += "\tAircraft => Units: #{troops.size}; Strength: #{troops.inject(0) {|sum, u| sum + u.strength}}"
        end
        troops = @units.select {|u| u.is_naval?}
        unless troops.empty?
          info += "\n" unless info.empty?
          info += "\tNaval => Units: #{troops.size}; Strength: #{troops.inject(0) {|sum, u| sum + u.strength}}"
        end
      end
      info
    end
    
    def terrain_info
      "Total Terrains: #{terrains.size}; Bases: #{base_count}"
    end
    
    def extended_terrain_info
      info = ""
      unless @terrains.empty?
        turfs = @terrains.select {|t| t.is_airfield?}
        unless turfs.empty?
          info += "\tAirfields: #{turfs.size}"
        end
        turfs = @terrains.select {|t| t.is_harbor?}
        unless turfs.empty?
          info += "\n" unless info.empty?
          info += "\tHarbors: #{turfs.size}"
        end
      end
      info
    end
    
    def salary_info
      "Income: #{salary}"
    end
    
  end
end
