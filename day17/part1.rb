#!/usr/bin/env ruby

require './grid.rb'

lines = IO.readlines(ARGV[0]).map(&:strip)
@grid = Grid.new

matcher = /([xy])=(\d+),\s*([xy])=(\d+)\.\.(\d+)/

# Build the board. This is mostly just a matter of parsing the commands in the
# input file and converting them into an X,Y grid. We also calculate the limits
# of the grid so that we count things in the right region later.

@limits = [Float::INFINITY, 0, Float::INFINITY, 0]

while lines.any?
  md = matcher.match lines.shift
  d0 = md[2].to_i
  d10 = md[4].to_i
  d11 = md[5].to_i
  if md[1] == 'x'
    x = d0
    (d10..d11).each do |y|
      @grid.set(x,y,:clay)
    end

    @limits[0] = d0 if d0 < @limits[0]
    @limits[1] = d0 if d0 > @limits[1]
    @limits[2] = d10 if d10 < @limits[2]
    @limits[3] = d11 if d11 > @limits[3]
  else
    y = d0
    (d10..d11).each do |x|
      @grid.set(x,y,:clay)
    end

    @limits[0] = d10 if d10 < @limits[0]
    @limits[1] = d11 if d11 > @limits[1]
    @limits[2] = d0 if d0 < @limits[2]
    @limits[3] = d0 if d0 > @limits[3]
  end
end

@limits[0] -= 1
@limits[1] += 1
puts @limits.inspect
@grid.disp @limits

# Simulate a stream of running water. 
#
# A drop of water falls until it hits clay, more water, or the bottom of the
# map; then it rolls left AND right until it either hits clay or is capable of
# falling again (because there's nothing underneath it). 
#
# If either roll results in a fall, stop processing this drop. If BOTH rolls
# are blocked by clay, we're in a basin. In that case, fill the row with WATER,
# back up one vertical step, and try rolling again.
#
# Remember that every space we touch (either by falling or rolling) needs to be
# marked WET. (Some of these will be overwritten with WATER later, which is
# fine.)

def falling_drop(px, py)
  falling = true
  while falling
    puts "Drop at (#{px},#{py}), falling"

    if py == @limits[3]
      puts "Stopping at edge of world"
      return
    end

    case @grid.get(px, py+1)
    when NilClass
      @grid.set px, py+1, :wet
      py += 1
    when :wet
      py += 1
    when :clay
      puts "Stopped by clay at (#{px},#{py+1}), rolling"
      falling = false
    when :water
      puts "Stopped by water at (#{px},#{py+1}), rolling"
      falling = false
    else
      puts "Something beneath us, rolling"
      falling = false
    end
  end

  filling = true
  while filling

    show_grid_near(px,py)

    puts "Rolling left"
    left = rolling_drop(px,py,-1)
    show_grid_near(px,py)

    puts "Rolling right"
    right = rolling_drop(px,py,1)
    show_grid_near(px,py)

    if left || right
      filling = false
    else
      puts "Filling a line from (#{px},#{py})"
      tx = px
      while @grid.get(tx,py) != :clay
        @grid.set tx, py, :water
        tx -= 1
      end
      tx = px
      while @grid.get(tx,py) != :clay
        @grid.set tx, py, :water
        tx += 1
      end
      py -= 1
    end
  end
end

# Roll in one direction for as long as possible. When you hit CLAY, stop and
# return FALSE to indicate that you were blocked. If there's nothing beneath
# you, you can fall, so add a falling droplet to the worklist and return TRUE
# to indicate a fall.

def rolling_drop(px, py, dx)
  mx = px
  my = py
  @grid.set(mx, py, :wet)
  while true
    puts "Drop at (#{mx},#{py}), rolling"

    s = @grid.get(mx + dx, py)
    case s
    when NilClass
      @grid.set(mx + dx, py, :wet)
      mx += dx
    when :wet
      mx += dx
    when :clay
      puts "Stopped by clay at (#{mx+dx},#{py})"
      return false
    else
      raise "Unexpected?"
    end

    case @grid.get(mx, py+1)
    when NilClass, :wet
      puts "Nothing beneath us at (#{mx},#{py+1}), falling"
      add_to_worklist(mx,py)
      return true
    end
  end
end

# Prints the current grid within a small window.

def show_grid_near(x,y)
  lim = [x-40,x+40,y-10,y+10]
  lim[0] = @limits[0] if @limits[0] > lim[0]
  lim[1] = @limits[1] if @limits[1] < lim[1]
  lim[2] = @limits[2] if @limits[2] > lim[2]
  lim[3] = @limits[3] if @limits[3] < lim[3]
  @grid.disp lim
end

# Adds a new droplet to the worklist. This save us from recursion and makes it
# easier to check whether we've already done a drop from this spot (or have one
# on the worklist already).

def add_to_worklist(x,y)
  if @donelist.include? [x,y]
    puts "(#{x},#{y}) has already been processed, refusing"
  elsif @worklist.include? [x,y]
    puts "(#{x},#{y}) is already on the worklist, refusing"
  else
    @worklist << [x,y]
  end
end

# Establish the to-do list and the done list. Initialize the work list with the
# starting point (500,0). Then repeat so long as there are more droplets to
# run. If a droplet is already under WATER, there's no need to process it
# because another droplet filled in on top of it already.

@donelist = []
@worklist = []
add_to_worklist(500,0)
while @worklist.any?
  puts "** Worklist (#{@worklist.count} items)"
  px, py = @worklist.shift
  @donelist << [px,py]
  case @grid.get(px, py)
  when :water
    puts "Skipping worklist item (#{px},#{py}) as it is already under water!"
    next
  end
  falling_drop(px, py)
end

# Print the final state of the board for posterity.

@grid.disp @limits

# Ask the grid to calculate the number of WATER or WET squares (part 1) and
# WATER squares (part 2)

puts "Wet squares: #{@grid.count_wet @limits}"
puts "Water squares: #{@grid.count_water @limits}"
