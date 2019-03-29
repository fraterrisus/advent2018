#!/usr/bin/env ruby

if ARGV[0]
  serial = ARGV[0].to_i
else
  # my input
  serial = 3628
end
dimension = 300

# I printed the first 10x10 grids so I could debug the calculator...

def peek(cells,x,y,dim)
  dim.times do |dy|
    c = cells[y-1+dy]
    dim.times do |dx|
      printf "%+3d ", c[x-1+dx]
    end
    puts
  end
end

# Cut-n-paste from part 1.

cells0 = []
dimension.times do |y|
  cells0[y] = Array.new(dimension)
  dimension.times do |x|
    rack_id = (x+1) + 10
    power = rack_id * (y+1)
    power += serial
    power *= rack_id
    power = (power / 100) % 10  #extract hundreds digit
    power -= 5
    cells0[y][x] = power
  end
end

# So I figured out pretty quickly that what I really wanted to do was memoize
# the solutions to the squares of size N so that I could compute the squares of
# size N+1 from those values, plus the new edges (read from the base power
# grid). It took some fiddling with ranges to figure out the right way to say
# "to get the power for the grid of size N+1 at (x,y), get the power of the
# grid of size N at (x,y) and then add the base power for (x,[y0..y1]) and
# ([x0..x1],y) but without double-counting the corners".
#
# Put more graphically, to expand from 3x3 to 4x4, I add the power of a 3x3
# grid at n to the 1x1 values of all of the x's in this picture:
#
#   n . . x
#   . . . x
#   . . . x
#   x x x x

def grid_power(cells,x,y,size)
  sum = 0
  (y...(y+size)).each do |my|
    sum += cells[my][x...(x+size)].sum
  end
  sum
end

dims = [-1,-1,-1]
maxpower = -1
cells_next = cells0
(1...dimension).each do |radius|
  cells_prev = cells_next
  cells_next = []
  (dimension-radius).times do |y|
    cells_next[y] = Array.new(dimension-radius)
    (dimension-radius).times do |x|
      thispower = 
        cells_prev[y][x] +
        cells0[y+radius][x...x+radius].sum +
        cells0[y..y+radius].map { |r| r[x+radius]}.sum
      cells_next[y][x] = thispower
      if thispower > maxpower
        maxpower = thispower
        dims = [x+1, y+1, radius+1]
        puts
        print "#{dims.inspect} (#{maxpower}) "
      end
    end
  end
  print "."
end
puts
