#!/usr/bin/env ruby

if ARGV[0]
  serial = ARGV[0].to_i
else
  # my input
  serial = 3628
end
dimension = 300

# Debugging tools that helped me figure out the off-by-one errors of 1-indexed
# problem descriptions and 0-indexed arrays in code.

def peek(x,y)
  c = @cells[y-1]
  printf "%+1d %+1d %+1d\n", c[x-1], c[x], c[x+1]
  c = @cells[y]
  printf "%+1d %+1d %+1d\n", c[x-1], c[x], c[x+1]
  c = @cells[y+1]
  printf "%+1d %+1d %+1d\n", c[x-1], c[x], c[x+1]
end

def index(x,y)
  @cells[y-1][x-1]
end

# This is just a transcription of the problem description method for
# calculating the power value of each node in the grid.

@cells = []
dimension.times do |y|
  @cells[y] = Array.new(300)
  dimension.times do |x|
    rack_id = (x+1) + 10
    power = rack_id * (y+1)
    power += serial
    power *= rack_id
    power = (power / 100) % 10  #extract hundreds digit
    power -= 5
    @cells[y][x] = power
  end
end

# Simple enough to loop over the grid, calculating the total power in 3x3
# squares everywhere, and running a max function.

dims = [-1,-1]
maxpower = -1
(dimension-2).times do |y|
  (dimension-2).times do |x|
    sum = @cells[y][x..x+2].sum +
      @cells[y+1][x..x+2].sum +
      @cells[y+2][x..x+2].sum
    if sum > maxpower
      dims = [x+1,y+1]
      maxpower = sum
    end
  end
end
puts "#{dims.inspect} (#{maxpower})"
