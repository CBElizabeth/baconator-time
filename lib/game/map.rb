module Tiles
  WideLadderTop = 0
  NarrowLadderTop = 1
  NarrowPlatformLeft = 2
  NarrowPlatformCenter = 3
  NarrowPlatformRight = 4
  WideLadder = 5
  NarrowLadder = 6
  WidePlatformLeft = 7
  WidePlatformCenter = 8
  WidePlatformRight = 9
  Box1 = 10
  Box2 = 11
  Blue = 12
  BlueBlock = 13
  Yellow = 14
  YellowBlock = 15
  Green = 16
  GreenBlock = 17
  Red = 18
  RedBlock = 19
end

class Map
  attr_reader :width, :height, :gems, :burgers

  def initialize(filename)
    @tileset = Gosu::Image.load_tiles("media/small-tileset.png", 70, 70, :tileable => true)
    @burger_plot = {a: [],
                b: []}

    lines = File.readlines(filename).map { |line| line.chomp }
    @height = lines.size
    @width = lines[0].size
    @tiles = Array.new(@width) do |x|
      Array.new(@height) do |y|
        case lines[y][x, 1]
          when '#'
            Tiles::NarrowLadderTop
          when '['
            Tiles::NarrowPlatformLeft
          when '-'
            Tiles::NarrowPlatformCenter
          when ']'
            Tiles::NarrowPlatformRight
          when '='
            Tiles::NarrowLadder
          when '{'
            Tiles::WidePlatformLeft
          when '_'
            Tiles::WidePlatformCenter
          when '}'
            Tiles::WidePlatformRight
          when 'b'
            Tiles::Blue
          when 'y'
            Tiles::Yellow
          when 'g'
            Tiles::Green
          when 'r'
            Tiles::Red
          when '%'
            burger_plotter(:a, x, y)
            nil
          when '&'
            burger_plotter(:b, x, y)
            nil
          else
            nil
        end
      end
    end
    @burgers = [Burger.new(@burger_plot[:a], self), Burger.new(@burger_plot[:b], self)]
  end

  def draw
    @height.times do |y|
      @width.times do |x|
        tile = @tiles[x][y]
        if tile
          @tileset[tile].draw(x * 70, y * 70, 0)
        end
      end
    end
    @burgers.each{ |b| b.draw }
  end

  # Solid at a given pixel position?
  def solid?(x, y)
    if ladder?(x, y)
      return false
    end
    y < 0 || @tiles[x / 70][y / 70]
  end

  def floor?(x, y, y_offset)
    floor = [2, 3, 4, 6, 16]
    floor.include?(@tiles[x / 70][(y.floor.to_i / 70) + y_offset])
  end

  def ladder?(x, y)
    ladders = [0, 1, 5, 6]
    ladders.include?(@tiles[x / 70][y / 70])
  end

  def burger?(x, y, y_offset = 0)
    @burgers[0].has_piece?(x, y.floor.to_i, y_offset) || @burgers[1].has_piece?(x, y.floor.to_i, y_offset)
  end

  def get_burger_piece(x, y, y_offset = 0)
    piece = nil
    @burgers.each do |burger|
      current_piece = burger.get_piece(x, y + y_offset)
      if current_piece
        piece = current_piece
      end
    end
    piece
  end

  def burger_plotter(key, x, y)
    @burger_plot[key].push([x, y], [x + 1, y], [x + 2, y])
  end

end
