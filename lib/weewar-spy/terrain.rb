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
    
    def is_base?
      :base == @type_sym
    end
    
    def is_airfield?
      :airfield == @type_sym
    end
    
    def is_harbor?
      :harbor == @type_sym
    end
    
    def self.base_count(terrains)
      terrains.select {|t| t.is_base?}.size
    end
    
    def self.report_for(terrains)
      # FIXME: Report Generation
      report = "\tTotal Terrains: #{terrains.size}; Bases: #{base_count(terrains)}\n"
      info = ""
      unless terrains.empty?
        turfs = terrains.select {|t| t.is_airfield?}
        unless turfs.empty?
          info += "\tAirfields: #{turfs.size}"
        end
        turfs = terrains.select {|t| t.is_harbor?}
        unless turfs.empty?
          info += "\n" unless info.empty?
          info += "\tHarbors: #{turfs.size}"
        end
      end
      unless info.empty?
        report += "\t~~~~~~~~~~~~~~~~~~~~\n"
        report += "\tExtended Terrain Info:\n"
        report += info + "\n"
        report += "\t~~~~~~~~~~~~~~~~~~~~\n"
      end
      report
    end
    
  end
end
