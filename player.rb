class Player < KinematicBody
  attr_accessor :inventory
  def initialize(x,y,color,x2)
    super(x,y,color,false, Materials::PLAYER)

    @inventory = Inventory.new() #players inventory
  end

  def explode()
    @inventory.items.each do |item|
      item.model.add
      $items.push(item)
      item.position = @position
      item.applyForce(Vector[rand(-22..22),rand(-70..-65)])
    end
    @inventory.items.clear
  end

end
