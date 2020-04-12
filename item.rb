class Item < KinematicBody
  attr_accessor :name
  def initialize(x,y,color)
    super(x,y,color,false, Materials::ITEM)
    @name = "Test Item"
  end

  def onUpdate
    $players.each do |p|
      if p.model.x <= @model.x + @model.size && p.model.x + p.model.size >= @model.x
        if p.model.y <= @model.y + @model.size && p.model.y + p.model.size >= @model.y
          touchedByPlayer(p)

          @model.remove
          $items.delete(self)
        end
      end
    end
  end

  def touchedByPlayer(p)
    p.inventory.addItem(self)
  end

end
