module Environments
  Environment = Struct.new(:gravity, :groundFriction, :airDensity, :coefficentOfDrag, :timeStep)

  AIR = Environment.new(2.8, 0.32, 0.04, 0.16, 0.65)

end
