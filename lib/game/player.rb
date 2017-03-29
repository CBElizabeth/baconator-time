class Player
  attr_reader :x, :y

  def initialize(map, x, y)
    @x, @y = x, y
    @dir = :left
    @map = map
    # Load all animation frames
    @climb1, @climb2, @celebrate1, @celebrate2,
        @walk1, @walk2, @standing = *Gosu::Image.load_tiles("media/female-tileset2.png", 40, 55)
    # This always points to the frame that is currently drawn.
    # This is set in update, and used in draw.
    @cur_image = @standing
  end

  def draw
    # Flip vertically when facing to the right.
    if @dir == :right
      offs_x = -25
      factor = 1.0
    else
      offs_x = 25
      factor = -1.0
    end
    @cur_image.draw(@x + offs_x, @y - 49, 0, factor, 1.0)
  end

  # Could the object be placed at x + offs_x/y + offs_y without being stuck?
  def would_fit(offs_x, offs_y)
    # Check at the center/top and center/bottom for map collisions
    not @map.solid?(@x + offs_x, @y + offs_y) and
        not @map.solid?(@x + offs_x, @y + offs_y - 45)
  end

  def can_climb(offs_x, offs_y)
    if offs_y < 0
      if !@map.solid?(@x, @y) && @map.ladder?(@x, @y + offs_y)
        return true
      end
    elsif offs_y > 0
      return @map.ladder?(@x + offs_x, @y + offs_y)
    end
  end

  def touch_burger
    piece = @map.get_burger_piece(@x, @y)
    if piece
      piece.touch
    end
  end

  def update(move_x, move_y)
    # Select image depending on action
    if move_x == 0 && move_y == 0 && !@map.ladder?(@x, @y)
      @cur_image = @standing
    elsif move_x != 0
      @cur_image = (Gosu.milliseconds / 175 % 2 == 0) ? @walk1 : @walk2
    elsif move_y != 0
      @cur_image = (Gosu.milliseconds / 175 % 2 == 0) ? @climb1 : @climb2
    elsif @map.ladder?(@x, @y)
      @cur_image = @climb1
    end

    # Directional walking, horizontal movement - check for floor/ladder top @ x +/- 1 / y + 1
    if move_x > 0
      @dir = :right
      move_x.times { if would_fit(1, 0) then @x += 1 end }
    end
    if move_x < 0
      @dir = :left
      (-move_x).times { if would_fit(-1, 0) then @x -= 1 end }
    end

    # Climbing, vertical movement
    if move_y < 0
      (-move_y).times { if can_climb(0, -1) then @y -= 1 end }
    end
    if move_y > 0
      move_y.times { if can_climb(0, 1) then @y += 1 end }
    end

    if @map.burger?(@x, @y)
      touch_burger
    end
  end
end