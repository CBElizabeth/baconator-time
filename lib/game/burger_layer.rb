class BurgerLayer
  attr_reader :layer_tiles, :left, :middle, :right

  def initialize(coords, images, map)
    @map = map
    @left = BurgerTile.new(coords.slice!(0), images.slice!(0))
    @middle = BurgerTile.new(coords.slice!(0), images.slice!(0))
    @right = BurgerTile.new(coords.slice!(0), images.slice!(0))
    @layer_tiles = [@left, @middle, @right]
  end

  def update
    if falling?
        @layer_tiles.each{ |tile|
          if tile.y < 11
            tile.y += 0.1
          end
        }
    end
    # elsif bumped?
    #   fall
    #   @layer_tiles.each{ |tile| tile.y += 0.1 }
    # end
  end

  def draw
    @layer_tiles.each{ |t| t.draw }
  end

  def falling?
    @left.falling & @middle.falling & @right.falling
  end

  def landing?
    @map.floor?(@left.x, @left.y, 2) || @map.burger?(@left.x, @left.y, 2)
  end

  def bumped?
    @map.burger?(@left.x, @left.y, -1)
  end

  def fall
    @layer_tiles.each do |tile|
      tile.falling = true
    end
  end

  def land
    @layer_tiles.each do |tile|
      tile.falling = false
    end
  end
end