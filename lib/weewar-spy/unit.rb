module WeewarSpy
  class Unit
    attr_reader :type, :strength, :location
    attr_reader :finished, :capturing
    attr_reader :unit_class, :type_sym

    SYMBOL_FOR_TYPE = {
      # Ground Infantry
      'Trooper'           => :linf,
      'Heavy Trooper'     => :hinf,
      # Ground Vehicles
      'Raider'            => :raider,
      'Tank'              => :tank,
      'Heavy Tank'        => :htank,
      'Light Artillery'   => :lart,
      'Heavy Artillery'   => :hart,
      # Ground Vehicles (Pro)
      'Assault Artillery' => :aart,
      'D.F.A.'            => :dfa,
      'Berserker'         => :bers,
      'Anti Aircraft'     => :anti_aircraft,
      # Amphibic Vechicles
      'Hovercraft'        => :hover,
      # Aircraft
      'Helicopter'        => :helicopter,
      'Jetfighter'        => :jetfighter,
      'Bomber'            => :bomber,
      # Naval
      'Speedboat'         => :speedboat,
      'Destroyer'         => :destroyer,
      'Submarine'         => :submarine,
      'Battleship'        => :battleship,
    }

    UNIT_CLASSES = {
      :linf => :soft,
      :hinf => :soft,
      :raider => :hard,
      :tank => :hard,
      :htank => :hard,
      :lart => :hard,
      :hart => :hard,
      :aart => :hard,
      :dfa => :hard,
      :bers => :hard,
      :anti_aircraft => :hard,
      :hover => :amphibic,
      :helicopter => :air,
      :jetfighter => :air,
      :bomber => :air,
      :submarine => :sub,
      :speedboat => :speedboat,
      :destroyer => :boat,
      :battleship => :boat
    }
    
    def initialize(unit)
      @type = unit['type']
      @type_sym = SYMBOL_FOR_TYPE[@type]
      @unit_class = UNIT_CLASSES[@type_sym]
      @strength = unit['quantity'].to_i
      @finished = (unit['finished'] == 'true')
      @capturing = (unit['capturing'] == 'true')
      @location = WeewarSpy::Hex.new(unit['x'], unit['y'], self)
    end
    
    def is_infantry?
      :soft == @unit_class
    end
    
    def is_vehicle?
      :hard == @unit_class or :amphibic == @unit_class
    end
    
    def is_aircraft?
      :air == @unit_class
    end
    
    def is_naval?
      :speedboat == @unit_class or :boat == @unit_class
    end
    
    # Experimental Rating Indicator
    def self.efficiency(units)
      return 0.0 if units.empty?
      troop_strength(units) / (10.0 * units.size) * 100.0
    end
    
    def self.troop_strength(units)
      units.inject(0) {|sum, u| sum + u.strength}
    end
    
    def self.report_for(units)
      # FIXME: Report Generation
      report = "\tTotal Units: #{units.size}; Troop Strength: #{troop_strength(units)}; Efficiency: #{sprintf('%2.2f', efficiency(units))}\n"
      info = ""
      unless units.empty?
        
        troops = units.select {|u| u.is_infantry?}
        unless troops.empty?
          info += "\tInfantry => Units: #{troops.size}; Strength: #{troop_strength(troops)}"
          infantry = troops.select {|t| :linf == t.type_sym}
          unless infantry.empty?
            info += "\n\t\tTroopers => Units: #{infantry.size}; Strength: #{troop_strength(infantry)}"
          end
          infantry = troops.select {|t| :hinf == t.type_sym}
          unless infantry.empty?
            info += "\n\t\tHeavy Troopers => Units: #{infantry.size}; Strength: #{troop_strength(infantry)}"
          end
        end
        
        troops = units.select {|u| u.is_vehicle?}
        unless troops.empty?
          info += "\n" unless info.empty?
          info += "\tVehicles => Units: #{troops.size}; Strength: #{troop_strength(troops)}"
          vehicles = troops.select {|t| :raider == t.type_sym}
          unless vehicles.empty?
            info += "\n\t\tRaiders => Units: #{vehicles.size}; Strength: #{troop_strength(vehicles)}"
          end
          vehicles = troops.select {|t| :tank == t.type_sym}
          unless vehicles.empty?
            info += "\n\t\tTanks => Units: #{vehicles.size}; Strength: #{troop_strength(vehicles)}"
          end
          vehicles = troops.select {|t| :htank == t.type_sym}
          unless vehicles.empty?
            info += "\n\t\tHeavy Tanks => Units: #{vehicles.size}; Strength: #{troop_strength(vehicles)}"
          end
          vehicles = troops.select {|t| :lart == t.type_sym}
          unless vehicles.empty?
            info += "\n\t\tLight Artillery => Units: #{vehicles.size}; Strength: #{troop_strength(vehicles)}"
          end
          vehicles = troops.select {|t| :hart == t.type_sym}
          unless vehicles.empty?
            info += "\n\t\tHeavy Artillery => Units: #{vehicles.size}; Strength: #{troop_strength(vehicles)}"
          end
          vehicles = troops.select {|t| :aart == t.type_sym}
          unless vehicles.empty?
            info += "\n\t\tAssault Artillery => Units: #{vehicles.size}; Strength: #{troop_strength(vehicles)}"
          end
          vehicles = troops.select {|t| :dfa == t.type_sym}
          unless vehicles.empty?
            info += "\n\t\tD.F.A. => Units: #{vehicles.size}; Strength: #{troop_strength(vehicles)}"
          end
          vehicles = troops.select {|t| :bers == t.type_sym}
          unless vehicles.empty?
            info += "\n\t\tBerserker => Units: #{vehicles.size}; Strength: #{troop_strength(vehicles)}"
          end
          vehicles = troops.select {|t| :anti_aircraft == t.type_sym}
          unless vehicles.empty?
            info += "\n\t\tAnti Aircraft => Units: #{vehicles.size}; Strength: #{troop_strength(vehicles)}"
          end
          vehicles = troops.select {|t| :hover == t.type_sym}
          unless vehicles.empty?
            info += "\n\t\tHovercraft => Units: #{vehicles.size}; Strength: #{troop_strength(vehicles)}"
          end
        end
        
        troops = units.select {|u| u.is_aircraft?}
        unless troops.empty?
          info += "\n" unless info.empty?
          info += "\tAircraft => Units: #{troops.size}; Strength: #{troop_strength(troops)}"
          aircraft = troops.select {|t| :helicopter == t.type_sym}
          unless aircraft.empty?
            info += "\n\t\tHelicopter => Units: #{aircraft.size}; Strength: #{troop_strength(aircraft)}"
          end
          aircraft = troops.select {|t| :jetfighter == t.type_sym}
          unless aircraft.empty?
            info += "\n\t\tJet Fighter => Units: #{aircraft.size}; Strength: #{troop_strength(aircraft)}"
          end
          aircraft = troops.select {|t| :bomber == t.type_sym}
          unless aircraft.empty?
            info += "\n\t\tBomber => Units: #{aircraft.size}; Strength: #{troop_strength(aircraft)}"
          end
        end
        
        troops = units.select {|u| u.is_naval?}
        unless troops.empty?
          info += "\n" unless info.empty?
          info += "\tNaval => Units: #{troops.size}; Strength: #{troop_strength(troops)}"
          ships = troops.select {|t| :speedboat == t.type_sym}
          unless ships.empty?
            info += "\n\t\tSpeedboat => Units: #{ships.size}; Strength: #{troop_strength(ships)}"
          end
          ships = troops.select {|t| :destroyer == t.type_sym}
          unless ships.empty?
            info += "\n\t\tDestroyer => Units: #{ships.size}; Strength: #{troop_strength(ships)}"
          end
          ships = troops.select {|t| :submarine == t.type_sym}
          unless ships.empty?
            info += "\n\t\tSub => Units: #{ships.size}; Strength: #{troop_strength(ships)}"
          end
          ships = troops.select {|t| :battleship == t.type_sym}
          unless ships.empty?
            info += "\n\t\tBattleship => Units: #{ships.size}; Strength: #{troop_strength(ships)}"
          end
        end
      end
      unless info.empty?
        report += "\t~~~~~~~~~~~~~~~~~~~~\n"
        report += "\tExtended Troop Info:\n"
        report += info + "\n"
        report += "\t~~~~~~~~~~~~~~~~~~~~\n"
      end
      report
    end
    
  end
end
