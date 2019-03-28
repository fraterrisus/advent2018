#!/usr/bin/env ruby

require './node.rb'

# Read the star positions and velocities out of the input file.

lines = IO.readlines(ARGV[0])
matcher = /position=<(.*),(.*)> velocity=<(.*),(.*)>/
nodes = lines.map do |l|
  md = matcher.match l
  Node.new(md[1].to_i, md[2].to_i, md[3].to_i, md[4].to_i)
end

# I'm not excited about the vagueness of the problem description on this one.
# It's too easy to get lost in thinking things like "what if there are stars
# that aren't part of the message" and "how large are the letters going to be"
# and "will they always be in English".
#
# My first thought was to assume that they would converge towards the origin,
# wait until there were any stars in that area, and then start rendering
# images. I inspected the images by hand until I found the right one.
# Conveniently, I'd already added the number of steps to the filename.

=begin
require 'chunky_png'

@radius = 256
def render(nodes)
  any = false
  png = ChunkyPNG::Image.new(@radius * 2, @radius * 2, ChunkyPNG::Color::BLACK)
  nodes.each do |n|
    if (n.x > (-1 * @radius) && n.x < @radius && n.y > (-1 * @radius) && n.y < @radius)
      png[(n.x+@radius),(n.y+@radius)] = ChunkyPNG::Color('white')
      any = true
    end
  end
  if any
    png.save("step#{@step}.png", :fast_rgba)
    return true
  else
    return false
  end
end
=end

# Reading through the solutions on Reddit afterwards, it looks like I had the
# right idea, but didn't take it far enough. I should have determined the total
# distance between stars and waited until that value was minimized, then
# rendered an image there. So then I went back and did it in text instead of
# using a PNG library...

def render(nodes)
  xes = nodes.map(&:x)
  yes = nodes.map(&:y)
  chrs = []
  ((yes.min)..(yes.max)).each do |y|
    chrs[y - yes.min] = Array.new(xes.max - xes.min, 0)
  end
  nodes.each do |n|
    y = n.y - yes.min
    x = n.x - xes.min
    chrs[n.y - yes.min][n.x - xes.min] = 1
  end
  chrs.each do |row|
    row.each do |col|
      print (col == 1) ? "*" : " "
    end
    puts
  end
end

@step = 0
previousdist = -1
while true
  totaldist = 0
  nodes.each do |n|
    # I should do an all-points-distance function but this serves the purpose just fine.
    totaldist += n.distance_to(nodes.first)
  end
  if previousdist != -1 && totaldist > previousdist
    # We've gone one step too far, so back up and then render
    nodes.each(&:reverse)
    render(nodes)
    puts
    puts "Time: #{@step}"
    break
  end
  previousdist = totaldist
  nodes.each(&:step)
  @step += 1
end
