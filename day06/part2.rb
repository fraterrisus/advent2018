#!/usr/bin/ruby

require './point.rb'

lines = IO.readlines(ARGV[0]).map(&:strip)

coords = []
lines.each do |l|
  c = l.split(/\s*,\s*/).map(&:to_i)
  p = Point.new(c[0], c[1])
  coords << p
end

# Select a grid of the minimum size that encompasses all points given in the
# input.

min_x = coords.min_by(&:x).x
max_x = coords.max_by(&:x).x
min_y = coords.min_by(&:y).y
max_y = coords.max_by(&:y).y
puts "Grid: (#{min_x},#{max_x}) - (#{min_y},#{max_y})"

# Iterate over the grid. Do an all-points-distance routine between here (this
# grid square) and every Point on the list. Sum the distances to every Point.
# Count the number of squares whose total distance is less than 10000.

count = 0
closest_indices = []
(min_x..max_x).each do |x|
  (min_y..max_y).each do |y|
    this = Point.new(x,y)
    dist = coords.map { |p| this.distance_to(p) }
    count += 1 if dist.sum < 10000
  end
end
puts "Region size: #{count}"
