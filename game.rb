require 'savio'
set width: 1400, height: 1000, resizable:true #window properties

require_relative 'Controller.rb'
require_relative 'Environment.rb'
require_relative 'Materials.rb'

require_relative 'KinematicBody.rb'
require_relative 'item.rb'
require_relative 'inventory.rb'
require_relative 'player.rb'

#the player
$players = []
$players.push(Player.new(100,50, 'blue', 30))

$items = []
$items.push(Item.new(300,50, 'green'))

#the ground
ground = Line.new(
  x1: 0, y1: Window.height - 50,
  x2: Window.width, y2: Window.height - 50,
  width: 1,
  color: 'red',
  z: 0
)

#huge wall of sliders
# gSlider = Slider.new(value: Environment::Gravity, displayName: "Gravity", min: 0.0, max: 20.0, x: 800, y: 50)
# fSlider = Slider.new(value: Environment::GroundFriction, displayName: "Ground Friction", min: 0.0, max: 2.0, x: 800, y: 100)
# aSlider = Slider.new(value: Environment::AirDensity, displayName: "Air Density", min: 0.0 ,max: 2.0, x: 800, y: 150)
# tSlider = Slider.new(value: Environment::TimeStep, displayName: "Time Step", min: 0.01 ,max: 2.0, x: 800, y: 200)
# dSlider = Slider.new(value: Environment::CoefficentOfDrag, displayName: "Coefficent Of Drag", min: 0.0 ,max: 2.0, x: 800, y: 250)
#
# mSlider = Slider.new(value: Materials::PLAYER.maxSpeed, displayName: "Max Speed", min: 1.0 ,max: 200.0, x: 1100, y: 50)
# bSlider = Slider.new(value: Materials::PLAYER.bounciness, displayName: "Bounciness", min: 0.0 ,max: 2.0, x: 1100, y: 100)
# wSlider = Slider.new(value: Materials::PLAYER.mass, displayName: "Mass", min: 0.1, max: 150, x: 1100, y: 150)
# sSlider = Slider.new(value: Materials::PLAYER.surfaceArea, displayName: "Surface Area", min: 0.01,max: 100, x: 1100, y: 200)
# zSlider = Slider.new(value: Materials::PLAYER.size, displayName: "Size", min: 1,max: 100, x: 1100, y: 250)
#
# leftSlider = Slider.new(value: Controller::Left, displayName: "Left Force", min: 0.0 ,max: 200.0, x: 500, y: 50)
# rightSlider = Slider.new(value: Controller::Right, displayName: "Right Force", min: 0.0 ,max: 200.0, x: 500, y: 100)
# upSlider = Slider.new(value: Controller::Up, displayName: "Up Force", min: 0.0, max: 200.0, x: 500, y: 150)
# downSlider = Slider.new(value: Controller::Down, displayName: "Down Force", min: 0.0,max: 20000.0, x: 500, y: 200)

#update the players physics update every frame along with the sliders values
update do
  # Environment::Gravity = gSlider.value
  # Environment::GroundFriction = fSlider.value
  # Environment::AirDensity = aSlider.value
  # Environment::TimeStep = tSlider.value
  # Environment::CoefficentOfDrag = dSlider.value
  #
  # Materials::PLAYER.maxSpeed = mSlider.value
  # Materials::PLAYER.bounciness = bSlider.value
  # Materials::PLAYER.mass = wSlider.value
  # Materials::PLAYER.surfaceArea = sSlider.value
  # Materials::PLAYER.size = zSlider.value

  $players.each do |p|
    p.physicsUpdate()
  end
  $items.each do |i|
    i.physicsUpdate()
    i.onUpdate
  end
end

#handle key input
on :key do |event|
  $players.each do |p|
    case event.type
    when :held
      case event.key
      when "a"
        p.applyForce(Vector[-leftSlider.value, 0]) #applies a leftward force
      when "d"
        p.applyForce(Vector[rightSlider.value, 0]) #applies a rightward force
      when "s"
        p.applyForce(Vector[0, downSlider.value]) #applies an insanely large downward force
      when "w"
        p.applyForce(Vector[0, -upSlider.value]) #applies a small upward force
      end
    when :down
      case event.key
      when "e"
        p.inventory.toggleShown()
      when "space"
        $items.push(Item.new(300,50, 'green'))
      end
    end
  end
end

show() #shows the window
