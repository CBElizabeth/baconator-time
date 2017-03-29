require 'rubygems'
require 'gosu'
require_relative './game/map.rb'
require_relative './game/player.rb'
require_relative './game/burger'
require_relative './game/burger_layer'
require_relative './game/burger_tile'

WIDTH, HEIGHT = 700, 850

class Game < (Example rescue Gosu::Window)
  def initialize
    super WIDTH, HEIGHT

    self.caption = "Baconator Time"

    @sky = Gosu::Image.new("media/subway-tile.png", :tileable => true)
    @map = Map.new("media/game_map.txt")
    @player = Player.new(@map, 100, 695)
  end

  def update
    move_x = 0
    move_y = 0

    move_x -= 5 if Gosu.button_down? Gosu::KB_LEFT
    move_x += 5 if Gosu.button_down? Gosu::KB_RIGHT
    move_y -= 5 if Gosu.button_down? Gosu::KB_UP
    move_y += 5 if Gosu.button_down? Gosu::KB_DOWN

    @player.update(move_x, move_y)
    # @player.collect_gems(@map.gems)
    @map.burgers.each { |burger| burger.update }
  end

  def draw
    @sky.draw 0, 0, 0
    @map.draw
    @player.draw
  end

  def button_down(id)
    case id
      when Gosu::KB_ESCAPE
        close
      else
        super
    end
  end
end

Game.new.show if __FILE__ == $0