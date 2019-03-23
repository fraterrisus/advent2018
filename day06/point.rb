class Point
  def initialize(x0,y0)
    @x = x0
    @y = y0
  end

  def x
    @x
  end

  def y
    @y
  end

  def distance_to(p)
    (self.y - p.y).abs + (self.x - p.x).abs
  end

  def to_s
    "(#{@x},#{@y})"
  end
end
