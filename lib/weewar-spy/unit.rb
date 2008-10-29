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
    
  end
end
