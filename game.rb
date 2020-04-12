require 'savio'
set width: 1400, height: 1000, resizable:true #window properties

require_relative 'inventory.rb'
require_relative 'item.rb'
require_relative 'KinematicBody.rb'
require_relative 'player.rb'

#the player
players = []
players.push(Player.new(100,50,5, 'blue', 30))
players.push(Player.new(300,50,10, 'red', 330))


#the ground
ground = Line.new(
  x1: 0, y1: Window.height - 50,
  x2: Window.width, y2: Window.height - 50,
  width: 1,
  color: 'red',
  z: 0
)

#update the players physics update every frame
update do
  players.each do |p|
    p.physicsUpdate()
  end
end

#handle key input
on :key do |event|
  players.each do |p|
  case event.type
    when :down
      case event.key
      when "e"
        #player.showInventory()
      when "space"
        p.sticky = !p.sticky #toggles if youre sticky
      when "a"
        p.applyForce(Vector[-80, 0]) #applies a leftward force
      when "d"
        p.applyForce(Vector[80, 0]) #applies a rightward force
      when "s"
        p.applyForce(Vector[0, 200]) #applies a large downward force
      end
    when :held
      case event.key
      when "w"
        p.applyForce(Vector[0, -30]) #applies a small upward force
      end
    end
  end
end

show() #shows the window
