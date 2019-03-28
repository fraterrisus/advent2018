#!/usr/bin/env ruby

class Node
  def initialize(x,y,dx,dy)
    @x = x
    @y = y
    @dx = dx
    @dy = dy
  end

  def step
    @x += @dx
    @y += @dy
  end

  def reverse
    @x -= @dx
    @y -= @dy
  end

  def x
    @x
  end

  def y
    @y
  end

  def position
    [@x, @y]
  end

  def to_s
    position.inspect
  end

  def distance_to(n)
    (self.x - n.x).abs + (self.y - n.y).abs
  end
end
