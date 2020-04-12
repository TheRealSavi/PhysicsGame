class Player < KinematicBody
  attr_accessor :inventory
  def initialize(x,y,color,x2)
    super(x,y,color,x2, Materials::PLAYER)

    @inventory = Inventory.new() #players inventory
  end
end
