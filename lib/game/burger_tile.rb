class BurgerTile
  attr_accessor :x, :y, :falling

  def initialize(coords, image)
    @x, @y, @image = coords[0], coords[1], image
    # puts @x.to_s + ', ' + @y.to_s + ': ' + @image.to_s
    @falling = false
  end

  def update(y)
    # check for change in Y and if changed, update?
    @y = y
  end

  def draw(offset = 40)
    @image.draw(@x * 70, (@y * 70) + offset, 0)
  end

  def touch
    @falling = true
  end
end