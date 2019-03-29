#!/usr/bin/env ruby

part2 = true

require './track.rb'
require './car.rb'

def print_board(t,c)
  t.each do |row|
    row.each do |x|
      if x.nil?
        print " "
      else
        done = false
        c.each do |car|
          if car.track == x
            print car.to_s
            done = true
            break
          end
        end
        print x.to_s unless done
      end
    end
    puts
  end
  puts
end

# Read input. It's important to use RSTRIP and not STRIP here to prevent
# leading spaces from being ripped off, which misaligns the board!

lines = IO.readlines(ARGV[0]).map(&:rstrip)

xdim = lines.map(&:size).max
ydim = lines.size

cars = []

# Build the empty array of tracks. Technically we don't need this once we build
# all the links, and we could free up the memory, but we use it for printing
# the board.

tracks = Array.new(ydim)
ydim.times do |y|
  tracks[y] = Array.new(xdim, nil)
end

# Iterate over every read in character. Assign it to the right type of Track.
# If it's also the starting location of a Car, build that object too.

lines.each_with_index do |l,y|
  l.split(//).each_with_index do |c,x|
    case c
    when '-'
      t = HorizontalStraight.new(x,y)
    when '|'
      t = VerticalStraight.new(x,y)
    when '/'
      t = CurveA.new(x,y)
    when '\\'
      t = CurveB.new(x,y)
    when '+'
      t = Intersection.new(x,y)
    when '>'
      t = HorizontalStraight.new(x,y)
      cars << Car.new(t, :east)
    when '<'
      t = HorizontalStraight.new(x,y)
      cars << Car.new(t, :west)
    when '^'
      t = VerticalStraight.new(x,y)
      cars << Car.new(t, :north)
    when 'v'
      t = VerticalStraight.new(x,y)
      cars << Car.new(t, :south)
    when ' '
      t = nil
    else
      raise
    end
    tracks[y][x] = t
  end
end

# Iterate over the board again, assigning neighbor links to tracks where
# appropriate. Make sure you don't fall off the board, and if two Horizontal
# segments lie parallel to each other, prevent them from linking.

ydim.times do |y|
  xdim.times do |x|
    track = tracks[y][x]
    next if track.nil?
    track.north = tracks[y-1][x] if y-1 >= 0 && !track.is_a?(HorizontalStraight)
    track.south = tracks[y+1][x] if y+1 < ydim && !track.is_a?(HorizontalStraight)
    track.west = tracks[y][x-1] if x-1 >= 0 && !track.is_a?(VerticalStraight)
    track.east = tracks[y][x+1] if !track.is_a?(VerticalStraight)
  end
end

# Main loop. Sort the cars by position (y first, then x) to get the running
# order. The iteration code is captured inside the Car class. After each car
# moves, detect collisions.
#
# In part 1, if we detect a collision, note the position and exit immediately.
#
# In part 2, if we detect a collision, remove both cars from the track. When we
# end a tick with only one car left, print its position and exit.

#print_board(tracks, cars)
tick = 0
while true
  cars.select(&:active?).sort_by { |c| c.position.reverse }.each do |c|
    c.advance
    cars.select(&:active?).each do |d|
      next if d == c
      if c.position == d.position
        puts "Collision at t=#{tick} #{c.position.inspect}"
        if part2
          c.deactivate!
          d.deactivate!
        else
          exit
        end
      end
    end
  end
  #print_board(tracks, cars)
  
  if part2
    active_cars = cars.select(&:active?)
    if active_cars.size == 1
      puts "Only one car left!"
      puts active_cars[0].position.inspect
      exit
    end
  end

  tick += 1
end
