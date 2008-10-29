module WeewarSpy
  class Terrain
    attr_reader :type, :type_sym, :location
    attr_reader :finished

    SYMBOL_FOR_TYPE = {
      'Airfield' => :airfield,
      'Base'     => :base,
      'Harbor'   => :harbor
    }
    
    def initialize(terrain)
      @type = terrain['type']
      @type_sym = SYMBOL_FOR_TYPE[@type]
      @finished = (terrain['finished'] == 'true')
      @location = WeewarSpy::Hex.new(terrain['x'], terrain['y'], self)
    end
    
    def generates_income?
      :base == @type_sym
    end
    
  end
end
