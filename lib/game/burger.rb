class Burger
  attr_reader :burger_layers, :bun_top, :toppings, :patty, :bun_bottom

  def initialize(coords, map)
    @map = map
    burger_tileset = Gosu::Image.load_tiles("media/burger-tileset.png", 70, 30, :tileable => true)
    @bun_top = BurgerLayer.new(coords.slice!(0, 3), burger_tileset.slice!(0, 3), @map)
    @toppings = BurgerLayer.new(coords.slice!(0, 3), burger_tileset.slice!(0, 3), @map)
    @patty = BurgerLayer.new(coords.slice!(0, 3), burger_tileset.slice!(0, 3), @map)
    @bun_bottom = BurgerLayer.new(coords.slice!(0, 3), burger_tileset.slice!(0, 3), @map)
    @burger_layers = [@bun_top, @toppings, @patty, @bun_bottom]
  end

  def update
    @burger_layers.each do |layer|
      layer.update
    end
  end

  def draw
    @burger_layers.each{ |l| l.draw }
  end

  # needs to know when all layers have fallen

  def has_piece?(x, y, y_offset = 0)
    get_piece(x, y, y_offset).class == BurgerTile
  end

  def get_piece(x, y, y_offset = 0)
    @burger_layers.find do |layer|
      layer.layer_tiles.find do |piece|
        if (x / 70) == piece.x && ((y / 70) + y_offset) == piece.y
          return piece
        end
      end
    end
  end
end