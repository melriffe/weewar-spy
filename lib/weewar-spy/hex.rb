module WeewarSpy
  class Hex
    attr_reader :owner, :x, :y
    
    def initialize(x, y, owner)
      @owner = owner
      @x = x
      @y = y
    end
    
    def to_s
      "(#{x}, #{y})"
    end
    
  end
end
