class Inventory
  attr_reader :items, :slots
  def initialize()
    @z = 1000
    @size = 315
    @x = Window.width / 2 - @size / 2
    @y = Window.height / 2 - @size / 2
    @ui = Image.new('inventory.jpg', x: @x, y: @y, z: @z, size: @size)
    @ui.remove
    @shown = false

    @slots = 15

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

    layer = 0
    @items.each_with_index do |item, i|
      lengthOfItemsInLayer = 0
      itemsInLayer = 0

      itemsInLayer = @displayItems.count % 5
      if @displayItems.count % 5 == 0
        layer +=1
        itemsInLayer = 0
      end
      @displayItems.push(Text.new(item.name, x: @x + 15 + (63 * itemsInLayer), y: @y + 30 + ( 63 * (layer - 1)), z: @z +1, color: 'black'))
      @displayIcons.push(Square.new(x: @x + 15 + (63 * itemsInLayer) + (@displayItems[i].width / 2), y: @y + 15 + (63 * (layer - 1)), z: @z + 2, size: item.model.size, color: item.model.color))
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
