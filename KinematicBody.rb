require "matrix" #this is the builtin ruby library for vectors
class KinematicBody
  attr_reader :touchingGround
  attr_accessor :mass, :model
  def initialize(x,y,color,x2, material)
    #these are the pretty labels
    if x2 != false
      @label = {
        :position => Text.new("s", x: x2, y: 30),
        :velocity => Text.new("v", x: x2, y: 60),
        :acceleration => Text.new("a", x: x2, y: 90),
        :grounded => Text.new("g", x: x2, y: 120),
        :touchingGround => Text.new("t", x: x2, y: 150)
      }
    else
      @label = false
    end

    @material = material
    @environment = Environments::AIR

    @color = color #color of the square

    @grounded = false #true when on the ground and not moving vertically. disables gravity.
    @touchingGround = false #true when touching ground. used for friction.

    @position = Vector[x, y]
    @velocity = Vector[0,0]
    @acceleration = Vector[0,0]

    #the viewmodel
    @model = Square.new(
      color: @color,
      x: @position[0], y: @position[1],
      size: @material.size
    )
  end

  #this is how you move him, its like giving it a shove. you just tell it how hard to move.
  def applyForce(vector)
    vector = vector.clone
    force = vector / @material.mass
    @grounded = false         #just use this opportunity to check if it really is grounded
    @acceleration += force   #adds the force to this frames acceleration
  end

  def gravity() #calculates and returns the force of gravity on the player
    g = @environment.gravity     #gravity constant
    forceDown = @material.mass * g
    return Vector[0, forceDown]
  end

  def friction() #calculates and returns the force of friction on the player
    coef = @environment.groundFriction

    v = Vector[@velocity[0], 0] #velocity vector with no y component
    u = Vector[(v[0] / (v.r + 0.01)), (v[1] / (v.r + 0.01))] #velocity vector with no magnitude, only direction
    u *= -1 #reverse direction so it opposes
    u *= coef #multiply by the coefficent of friction to get the magnitude
    u *= @material.mass * @environment.gravity #multiply by the Normal force to increase the magnitude.

    if u[0] > 0.0 && u[0] < 0.05 || u[0] < 0.0 && u[0] > -0.05 #get rid of the friction component if its really small
      u[0] = 0
    end

    return u
  end

  def drag()
    density = @environment.airDensity
    surfaceArea = @material.surfaceArea
    coef = @environment.coefficentOfDrag

    velocity = Vector[@velocity[0], @velocity[1]]

    magnitudeVelocity = velocity.magnitude
    unitVelocity = Vector[(velocity[0] / (velocity.r + 0.00001)), (velocity[1] / (velocity.r + 0.00001))]

    force = -0.5 * density * (magnitudeVelocity ** 2) * surfaceArea * coef * (unitVelocity)

    if force[0] > 0.0 && force[0] < 0.05 || force[0] < 0.0 && force[0] > -0.05
      force[0] = 0
    end
    if force[1] > 0.0 && force[1] < 0.05 || force[1] < 0.0 && force[1] > -0.05
      force[1] = 0
    end

    return force
  end

  def edgeLoop() #handles keeping the player on screen with teleporting edges
    if @position[0] < 0
      @position[0] = Window.width
    elsif @position[0] > Window.width
      @position[0] = 0
    end
  end

  def physicsUpdate() #gets called every frame to update physicss
    if !@grounded
      applyForce(gravity()) #applies force of gravity unless its grounded. this stops infinte little jittering.
    end
    if @touchingGround
      applyForce(friction()) #applies force of friction
    end
    applyForce(drag())

    @velocity += @acceleration * @environment.timeStep #calculates additional velocity with this frames determined acceleration vector

    #these make sure the velocity is within range of max speed
    @velocity[0] = @velocity[0].clamp(-@material.maxSpeed, @material.maxSpeed)
    @velocity[1] = @velocity[1].clamp(-@material.maxSpeed, @material.maxSpeed)

    if @velocity[0] > 0.0 && @velocity[0] < @environment.timeStep || @velocity[0] < 0.0 && @velocity[0] > -@environment.timeStep
      @velocity[0] = 0
    end

    #calculates addition to the potition based on the final velocity
    @position += @velocity * @environment.timeStep

    if @position[1] >= (Window.height - 50) - @model.size
      @touchingGround = true
      @position[1] = (Window.height - 50) - @model.size
      @velocity[1] *= -1 * @material.bounciness

      if @velocity[1] > 0.0 && @velocity[1] < @environment.timeStep || @velocity[1] < 0.0 && @velocity[1] > -@environment.timeStep
        @velocity[1] = 0
      end
      if @velocity == Vector[0,0]
        @grounded = true
      end
    else
      @touchingGround = false
    end

    edgeLoop() #runs the edgeloop that handles teleporting it around the edge
    @model.x = @position[0] #updating the viewmodels position so we can see him go
    @model.y = @position[1]

    #these are just all the labels and formatting the strings so they look pretty
    if @label != false
      @label[:grounded].text = "Grounded:" + @grounded.to_s
      @label[:touchingGround].text = "Touching Ground:" + @touchingGround.to_s

      @label[:position].text = "Position:" + ('%-8.8s' % @position[0].round(8).to_f).gsub(' ', '0') + "," + ('%-8.8s' % @position[1].round(8).to_f).gsub(' ', '0')
      @label[:velocity].text = "Velocity:" + ('%-8.8s' % @velocity[0].round(8).to_f).gsub(' ', '0') + "," + ('%-8.8s' % @velocity[1].round(8).to_f).gsub(' ', '0')
      @label[:acceleration].text = "Acceleration:" + ('%-8.8s' % @acceleration[0].round(8).to_f).gsub(' ', '0') + "," + ('%-8.8s' % @acceleration[1].round(8).to_f).gsub(' ', '0')
    end

    @acceleration = Vector[0,0] #erase this frames acceleration so that we have a nice fresh start next frame.
  end
end
