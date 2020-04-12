class Player < KinematicBody
  attr_accessor :mover
  def initialize(x,y,mass,color,x2)

    #these are the pretty labels
    @label = {
      :position => Text.new("s", x: x2, y: 30),
      :velocity => Text.new("v", x: x2, y: 60),
      :acceleration => Text.new("a", x: x2, y: 90),
      :grounded => Text.new("g", x: x2, y: 120),
      :sticky => Text.new("sticky", x: x2, y: 150),
      :touchingGround => Text.new("t", x: x2, y: 180)
    }
    super(x,y,mass,color)

    @inventory = Inventory.new() #players inventory
  end
end
