require "matrix" #this is the builtin ruby library for vectors
class KinematicBody
  attr_reader :touchingGround
  attr_accessor :sticky, :mass
  def initialize(x,y,mass,color)
    @size = 50 #size of the square
    @color = color #color of the square

    @timeStep = 0.6 #basically the speed of the physics
    @sticky = false #makes you sticky
    @grounded = false #true when on the ground and not moving vertically. disables gravity.
    @touchingGround = false #true when touching ground. used for friction.
    @maxSpeed = 200 #max velocity possible to travel
    @mass = mass #mass of the dude
    @bounciness = 0.8 #bounciness factor. 1 = 100%
    @position = Vector[x, y]
    @velocity = Vector[0,0]
    @acceleration = Vector[0,0]

    #the viewmodel
    @model = Square.new(
      color: @color,
      x: @position[0], y: @position[1],
      size: @size
    )
  end

  #this is how you move him, its like giving it a shove. you just tell it how hard to move.
  def applyForce(vector)
    vector = vector.clone
    force = vector / @mass
    @grounded = false         #just use this opportunity to check if it really is grounded
    @acceleration += force   #adds the force to this frames acceleration
  end

  def gravity() #calculates and returns the force of gravity on the player
    g = 2.0     #gravity constant
    forceDown = @mass * g
    return Vector[0, forceDown]
  end

  def friction() #calculates and returns the force of friction on the player
    if @touchingGround #determines the coefficent of friction based on if its in air or on ground

      if @sticky #determines how much it sticks to the ground
        coef = 0.88 #sticky ground
      else
        coef = 0.22 #not sticky ground
      end

      v = Vector[@velocity[0], 0]
      u = Vector[(v[0] / (v.r + 0.01)), (v[1] / (v.r + 0.01))]
      u *= -1
      u *= coef
      u *= @mass * 2.0 #Weight from gravity

      if u[0] > 0.0 && u[0] < 0.05 || u[0] < 0.0 && u[0] > -0.05
        u[0] = 0
      end

      return u
    else
      return Vector[0,0]
    end
  end

  def drag()
    density = 0.02
    surfaceArea = 1
    coef = 0.1

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
    applyForce(friction()) #applies force of friction
    applyForce(drag())

    @velocity += @acceleration * @timeStep #calculates additional velocity with this frames determined acceleration vector

    #these make sure the velocity is within range of max speed
    @velocity[0] = @velocity[0].clamp(-@maxSpeed, @maxSpeed)
    @velocity[1] = @velocity[1].clamp(-@maxSpeed, @maxSpeed)

    if @velocity[0] > 0.0 && @velocity[0] < 0.52 || @velocity[0] < 0.0 && @velocity[0] > -0.52
      @velocity[0] = 0
    end

    #calculates addition to the potition based on the final velocity
    prevPosition = Vector[@position[0],@position[1]]

    @position += @velocity * @timeStep

    if @position[1] >= Window.height - 100
      @touchingGround = true
      @position[1] = Window.height - 100
      if @sticky == true  #if its sticky when it touches the ground
        #@velocity[1] *= -@bounciness * 0.2 #if its sticky reverse the velocity and scale it by the 20% bounce factor
        @velocity[1] *= -1 * @bounciness * 0.2
      else
        #@velocity[1] *= -@bounciness #if its not sticky reverse the velocity and scale it by the bounce factor
        @velocity[1] *= -1 * @bounciness
      end
      if @velocity[1] > 0.0 && @velocity[1] < 0.6 || @velocity[1] < 0.0 && @velocity[1] > -0.6
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
    @label[:grounded].text = "Grounded:" + @grounded.to_s
    @label[:touchingGround].text = "Touching Ground:" + @touchingGround.to_s
    @label[:sticky].text = "Sticky:" + @sticky.to_s

    @label[:position].text = "Position:" + ('%-8.8s' % @position[0].round(2).to_f).gsub(' ', '0') + "," + ('%-8.8s' % @position[1].round(2).to_f).gsub(' ', '0')
    @label[:velocity].text = "Velocity:" + ('%-8.8s' % @velocity[0].round(2).to_f).gsub(' ', '0') + "," + ('%-8.8s' % @velocity[1].round(2).to_f).gsub(' ', '0')
    @label[:acceleration].text = "Acceleration:" + ('%-8.8s' % @acceleration[0].round(2).to_f).gsub(' ', '0') + "," + ('%-8.8s' % @acceleration[1].round(2).to_f).gsub(' ', '0')

    @acceleration = Vector[0,0] #erase this frames acceleration so that we have a nice fresh start next frame.
  end
end
