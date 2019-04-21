#!/usr/bin/env ruby

require './room.rb'

@regex = IO.readlines(ARGV[0]).map(&:strip).join.split(//)
@rooms = [ ]

#
# Code to print out a fancy maze of rooms using UNICODE art.
#

@lookup = [
  "\u25aa", # - - - -  0
  "\u2579", # N - - -  1
  "\u257b", # - S - -  2
  "\u2503", # N S - -  3
  "\u257a", # - - E -  4
  "\u2517", # N - E -  5
  "\u250f", # - S E -  6
  "\u2523", # N S E -  7
  "\u2578", # - - - W  8
  "\u251b", # N - - W  9
  "\u2513", # - S - W  a
  "\u252b", # N S - W  b
  "\u2501", # - - E W  c
  "\u253b", # N - E W  d
  "\u2533", # - S E W  e
  "\u254b", # N S E W  f
]

def print_board
  minx = @rooms.map(&:x).min
  maxx = @rooms.map(&:x).max
  miny = @rooms.map(&:y).min
  maxy = @rooms.map(&:y).max
  xdim = 1 + maxx - minx
  ydim = 1 + maxy - miny

  ydim.times do |y|
    xdim.times do |x|
      px = x + minx
      py = y + miny
      r = @rooms.select { |r| r.at?(px, py) }
      if r.any?
        r = r[0]
        val = 0
        val += 1 if r.north 
        val += 2 if r.south
        val += 4 if r.east
        val += 8 if r.west
        print @lookup[val]
      end
    end
    puts
  end
end

#
# The meat of the board-building algorithm. The solution is based on the idea
# of running finite state automata by keeping multiple pointers over a graph,
# except in this case we're building the graph (determining legal moves between
# rooms) as we go. 
#
# The key insight is to recurse when we hit a grouping operator (|). The
# recursion takes the current worklist and runs each alternation separately,
# splitting the input worklist into N parts for N branches, and returns all the
# results. So N(E|W|) starts with one pointer, steps N, then sees the branch.
# When the recursion returns, it has split into three pointers {NE,NW,N}.
#
# If "^" we're at the start, so initialize with a ROOM at (0,0) and fork.
# If "$" we're at the end, so just return because we don't care about the state
#   of the worklist when we finish.
# If "(" recurse as above.
# If "|" then save everything you've done so far, reset to the beginning of the
#   most recent recursion (this is why we use recursion, to be able to save
#   this point), and keep going with the next branch.
# If ")" we're done with a recursion pass; put everything together and return.
# If a direction letter, then move everything in the current worklist one step
#   in that direction; see #process_node below.
#

def fork(prev_worklist)
  #puts "Called fork with worklist: ["
  #prev_worklist.each { |r| puts "  #{r.to_s}" }
  #puts "]"

  worklist = prev_worklist.dup
  returnables = []
  while ch = @regex.shift
    #puts "Worklist: ["
    #worklist.each { |r| puts "  #{r.to_s}" }
    #puts "]"
    #puts "Returnables: #{returnables.size}"

    case ch
    when '('
      #puts "Switch -- start"
      worklist = fork(worklist)
    when ')'
      #puts "Switch -- end"
      return returnables + worklist
    when '|'
      #puts "Switch -- alternator"
      returnables = worklist
      worklist = prev_worklist.dup
    when 'N'
      worklist = worklist.map { |n| process_node n, :north }
    when 'E'
      worklist = worklist.map { |n| process_node n, :east }
    when 'W'
      worklist = worklist.map { |n| process_node n, :west }
    when 'S'
      worklist = worklist.map { |n| process_node n, :south }
    when '^'
      r = Room.new(0,0)
      @rooms = [ r ]
      return fork([ r ])
    when '$'
      return
    else
      raise "Unexpected character '#{ch}'"
    end

    worklist.uniq! { |r| [r.x, r.y] }

  end
end

#
# Look for a node that already exists in the direction we're moving. If one
# exists, great; otherwise, create a new one. Either way, link it to this room
# (me.north = them, them.south = me), then return the new node since we
# advanced into it as part of this process.
#
# This could definitely be more efficient; we just keep an unordered list of
# rooms that we've created and let Array#select do the work.
#

def process_node(n, dir)
  dx, dy = n.deltas(dir)
  mx = n.x + dx
  my = n.y + dy
  #puts "process (#{n.x},#{n.y},#{dir})"
  m = @rooms.select { |r| r.at? mx, my }
  if m.any?
    #puts "  found existing room at (#{mx},#{my})"
    m = m[0]
  else
    #puts "  no node found, creating new room at (#{mx},#{my})"
    m = Room.new(mx, my)
    @rooms << m
  end
  n.public_send(dir.to_s + "=", m)
  m.public_send(m.opposite(dir).to_s + "=", n)
  m
end

# 
# After we build the board we still need to run a breadth-first search to find
# (1) the furthest-away room and (2) all rooms that are more than X doors away.
#
# Fortunately we did this already back in day 15.
#

@max_depth = 0
@far_away_rooms = 0

def bfs(root)
  root.distance = 0
  visited = [ ]
  worklist = [ root ]
  while room = worklist.shift
    newdist = room.distance + 1
    room.neighbors.each do |other|
      unless visited.include? other
        other.distance = newdist
        @max_depth = newdist if newdist > @max_depth
        @far_away_rooms += 1 if newdist >= 1000
        worklist << other
      end
    end
    visited << room
  end
end

#
# Main method.
# Start the building process with an empty list and let it do its work.
# Print the board, just for fun.
# Run the BFS to compute the values we need, then print them.
#

fork []
print_board
bfs @rooms[0]
puts "Max depth: #{@max_depth}"
puts "Far away rooms: #{@far_away_rooms}"
