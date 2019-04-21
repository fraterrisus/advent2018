class Room
  def initialize(x,y)
    @x = x
    @y = y
    @north = nil
    @east = nil
    @south = nil
    @west = nil
    @distance = nil
  end

  def neighbors
    [@north, @south, @east, @west].compact
  end

  def distance
    @distance
  end

  def distance=(d)
    @distance = d
  end

  def deltas(dir)
    case dir
    when :north
      [0, -1]
    when :south
      [0, 1]
    when :west
      [-1, 0]
    when :east
      [1, 0]
    else
      raise "Unexpected value #{dir}"
    end
  end

  def opposite(dir)
    case dir
    when :north
      :south
    when :south
      :north
    when :east
      :west
    when :west
      :east
    else
      raise "Unexpected value #{dir}"
    end
  end

  def at?(x,y)
    @x == x && @y == y
  end

  def north
    @north
  end

  def north=(n)
    @north = n
  end

  def west
    @west
  end

  def west=(n)
    @west = n
  end

  def east
    @east
  end

  def east=(n)
    @east = n
  end

  def south
    @south
  end

  def south=(n)
    @south = n
  end

  def x
    @x
  end

  def y
    @y
  end

  def to_s
    "<Room (#{x},#{y})" +
      " N:" + (@north.nil? ? "nil" : "(#{@north.x},#{@north.y})") +
      " E:" + (@east.nil?  ? "nil" : "(#{@east.x},#{@east.y})") +
      " W:" + (@west.nil?  ? "nil" : "(#{@west.x},#{@west.y})") +
      " S:" + (@south.nil? ? "nil" : "(#{@south.x},#{@south.y})") +
      ">"
  end

end
