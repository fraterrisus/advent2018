#!/usr/bin/env ruby

class Track
  def initialize(x,y)
    @x = x
    @y = y
    @outs = {
      north: nil,
      south: nil,
      east: nil,
      west: nil,
    }
  end

  def position
    [ @x, @y ]
  end

  def next(facing)
    @outs[facing]
  end

  def north
    @outs[:north]
  end

  def north=(t)
    @outs[:north] = t
  end

  def south
    @outs[:south]
  end

  def south=(t)
    @outs[:south] = t
  end

  def east
    @outs[:east]
  end

  def east=(t)
    @outs[:east] = t
  end

  def west
    @outs[:west]
  end

  def west=(t)
    @outs[:west] = t
  end

  protected

  def describe
    "(#{@x},#{@y}) #{"N " if @outs[:north]}#{"S " if @outs[:south]}#{"E " if @outs[:east]}#{"W " if @outs[:west]}"
  end
end

class HorizontalStraight < Track
  def new_facing(current_facing)
    case current_facing
    when :east
      :east
    when :west
      :west
    else
      raise RuntimeError, "horizontal track at #{self.position.inspect} was asked for #{current_facing}"
    end
  end

  def to_s
    '-'
  end
end

class VerticalStraight < Track
  def new_facing(current_facing)
    case current_facing
    when :north
      :north
    when :south
      :south
    else
      raise
    end
  end

  def to_s
    '|'
  end
end

class CurveA < Track
  def new_facing(current_facing)
    case current_facing
    when :north
      :east
    when :south
      :west
    when :east
      :north
    when :west
      :south
    else
      raise
    end
  end

  def to_s
    '/'
  end
end

class CurveB < Track
  def new_facing(current_facing)
    case current_facing
    when :north
      :west
    when :south
      :east
    when :east
      :south
    when :west
      :north
    else
      raise
    end
  end

  def to_s
    '\\'
  end
end

class Intersection < Track
  def new_facing(current_facing)
    nil
  end

  def to_s
    '+'
  end
end
