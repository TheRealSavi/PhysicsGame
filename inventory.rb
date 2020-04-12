class Inventory
  attr_reader :items
  def initialize()
    @z = 1000
    @size = 315
    @x = Window.width / 2 - @size / 2
    @y = Window.height / 2 - @size / 2
    @ui = Square.new(x: @x, y: @y, z: @z, size: @size, color: 'white')
    @ui.remove
    @shown = false

    @items = []
    @displayItems = []
    @displayIcons = []
  end

  def toggleShown()
    @shown = !@shown
    if @shown
      showUI()
    else
      hideUI()
    end
  end

  def showUI()
    @ui.add
    @displayItems.clear

    @items.each_with_index do |item, i|
      lengthOfItems = 0
      @displayItems.each do |j|
        lengthOfItems += j.width
      end
      @displayItems.push(Text.new(item.name, x: @x + 15 + lengthOfItems + (15 * @displayItems.count), y: @y + 30, z: @z +1, color: 'black'))
      @displayIcons.push(Square.new(x: @x + 15 + lengthOfItems + (15 * (@displayItems.count - 1)) + (@displayItems[i].width / 2), y: @y + 15, z: @z + 2, size: item.model.size, color: item.model.color))
    end
  end

  def hideUI()
    @ui.remove
    @displayItems.each_with_index do |item, i|
      item.remove
    end
    @displayIcons.each_with_index do |icon, i|
      icon.remove
    end
    @displayItems.clear
    @displayIcons.clear
  end

  def addItem(item)
    @items.push(item)
  end
end
