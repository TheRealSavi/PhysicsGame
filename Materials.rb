module Materials
  Material = Struct.new(:size, :maxSpeed, :bounciness, :mass, :surfaceArea)

  ITEM = Material.new(10,150,0.85,2.2,0.2)

  PLAYER = Material.new(50,150,0.35,7.6,1.01)
end
