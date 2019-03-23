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
# input. Anything on the edges of that grid has an infinte region area, but
# we'll deal with that later.

min_x = coords.min_by(&:x).x
max_x = coords.max_by(&:x).x
min_y = coords.min_by(&:y).y
max_y = coords.max_by(&:y).y
puts "Grid: (#{min_x},#{max_x}) - (#{min_y},#{max_y})"

# Iterate over the grid. Do an all-points-distance routine between here (this
# grid square) and every point on the list. Determine the index (on the coords
# list) of the Point that is closest to this grid square. We actually don't
# care about the coordinates of this grid square any more, so just save the
# index of the closest Point on a list.

closest_indices = []
(min_x..max_x).each do |x|
  (min_y..max_y).each do |y|
    this = Point.new(x,y)
    dist = coords.map { |p| this.distance_to(p) }
    shortest = dist.index(dist.min)
    other = dist.rindex(dist.min)
    if other == shortest
#      puts "#{this}: #{shortest} #{coords[shortest]}"
      closest_indices << shortest
#    else
#      puts "#{this}: nil"
    end
  end
end

# Frequency count the indices.

index_count = Array.new(coords.count, 0)
closest_indices.each do |i|
  index_count[i] += 1
end
#puts index_count.inspect

# Pick the largest frequency count. The index of that value on the frequency
# list is also the index on the coords list. Check that Point; if it is the
# most extreme (min or max) in either dimension, then its value is actually
# infinite and we should discard it. Set its value to 0 so it doesn't come up
# next time and repeat. Otherwise we have found the largest non-infinite value,
# so print and exit.

done = false
until done
  largest_index = index_count.index(index_count.max)
  largest_point = coords[largest_index]
  if ((largest_point.x == min_x) || (largest_point.x == max_x) ||
      (largest_point.y == min_y) || (largest_point.y == max_y))
    index_count[largest_index] = 0
  else
    puts "Largest finite region size: #{index_count.max}"
    done = true
  end
end

