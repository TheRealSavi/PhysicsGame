require 'savio'
set width: 1400, height: 1000, resizable:true #window properties

require_relative 'Controller.rb'
require_relative 'Environments.rb'
require_relative 'Materials.rb'

require_relative 'KinematicBody.rb'
require_relative 'item.rb'
require_relative 'inventory.rb'
require_relative 'player.rb'

#the player
$players = []
$players.push(Player.new(100,50, 'blue', 30))

$items = []
$items.push(Item.new(300,50, 'green', 'Jello'))

#the ground
ground = Line.new(
  x1: 0, y1: Window.height - 50,
  x2: Window.width, y2: Window.height - 50,
  width: 1,
  color: 'red',
  z: 0
)

#update the players physics update every frame along with the sliders values
update do
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
        p.applyForce(Vector[-Controller::Left, 0]) #applies a leftward force
      when "d"
        p.applyForce(Vector[Controller::Right, 0]) #applies a rightward force
      when "s"
        p.applyForce(Vector[0, Controller::Down]) #applies an insanely large downward force
      when "w"
        p.applyForce(Vector[0, -Controller::Up]) #applies a small upward force
      when "space"
        $items.push(Item.new(Window.width / 2, 50, 'random', 'Jello'))
      end
    when :down
      case event.key
      when "e"
        p.inventory.toggleShown()
      when "q"
        p.explode()
      end
    end
  end
end

show() #shows the window
