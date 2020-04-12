class Item < KinematicBody
  attr_accessor :name
  def initialize(x,y,color,name)
    super(x,y,color,false, Materials::ITEM)
    @name = name
    @animating = false
    applyForce(Vector[rand(-30..30),rand(-30..30)])
  end

  def onUpdate
    $players.each do |p|
      if p.model.x <= @model.x + @model.size && p.model.x + p.model.size >= @model.x && p.model.y <= @model.y + @model.size && p.model.y + p.model.size >= @model.y
        if @model.opacity >= 1.0
          applyForce(Vector[0,-60])
        end
        if @model.size < @material.size + 20
          @position[0] -= 0.5
          @position[1] -= 0.5
          @model.size += 1
          @model.opacity -= 0.05
        else
          touchedByPlayer(p)
        end
      else
        if @model.opacity < 1.0
          @model.opacity += 0.05
        end
        if @model.size > @material.size && @animating == false
          @position[0] += 0.5
          @position[1] += 0.5
          @model.size -= 1
        end
        if @model.size <= @material.size
          @animating = true
        end
        if @animating == true && @model.size < @material.size + 5
          @position[0] -= 0.125
          @position[1] -= 0.125
          @model.size += 0.25
        elsif @animating == true && @model.size >= @material.size + 5
          @animating = false
        end
      end
    end
  end

  def touchedByPlayer(p)
    if p.inventory.items.count < p.inventory.slots
      p.inventory.addItem(self)
      @model.opacity = 1.0
      @model.size = @material.size
      @model.remove
      $items.delete(self)
    end
  end

end
