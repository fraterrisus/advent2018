#!/usr/bin/env ruby

require './unit.rb'
require 'colorize'

if ARGV[1]
  @part_two = true
  elf_attack_power = ARGV[1].to_i
else
  @part_two = false
  elf_attack_power = 3
end
tokens = IO.readlines(ARGV[0]).map { |l| l.rstrip.split(//) }
xdim = tokens.map(&:size).max
@floor = Array.new
tokens.size.times { @floor << Array.new(xdim) }
units = []

tokens.each_with_index do |row,y|
  row.each_with_index do |space,x|
    case space
    when '#'
      @floor[y][x] = :wall
    when 'G'
      unit = Unit.new(:goblin, x, y, 3)
      units << unit
      @floor[y][x] = unit
    when 'E'
      unit = Unit.new(:elf, x, y, elf_attack_power)
      units << unit
      @floor[y][x] = unit
    when '.'
      #redundant
      @floor[y][x] = nil
    else
      raise "Unexpected floor token #{space} at (#{x},#{y})"
    end
  end
end

def print_board(floor)
  puts
  print "  "
  i = 0
  floor[0].size.times do 
    print i%10
    i += 1
  end
  puts
  puts

  i = 0
  floor.each do |row|
    print "#{i%10} "
    i += 1
    row.each do |space|
      case space
      when :wall
        print '#'.light_white
      when Unit
        print 'E'.blue if space.elf?
        print 'G'.green if space.goblin?
      when nil
        print '.'
      when Numeric
        print (97 + (space%26)).chr.red
      else
        raise "Unexpected space #{space.inspect}"
      end
    end
    puts
  end
end

def should_update(p,x,y,v)
  return true if p[y][x].nil?
  return true if p[y][x].is_a?(Numeric) && p[y][x] > v
  false
end

def reachable_points(pos)
  x0, y0 = pos
  worklist = [ pos ]

  # deep copy
  points = Array.new
  @floor.each do |row|
    points << row.dup
  end
  points[y0][x0] = 0
  while worklist.any?
    x,y = worklist.shift
    #puts "Working on #{x},#{y}"
    newdist = points[y][x] + 1
    [ [x-1,y], [x+1,y], [x,y-1], [x,y+1] ].each do |a,b|
      if should_update(points,a,b,newdist)
        #puts "  Updating #{a},#{b} = #{newdist}"
        points[b][a] = newdist
        worklist << [a, b]
      end
    end
  end
  points
end

tick = 0
while true
  puts
  puts "----- Tick #{tick} -----"
  units.each { |u| u.new_turn }
  #print_board @floor

  # Units execute in Reading Order, so iterate over the board in Reading Order,
  # skipping squares that don't contain a Unit that hasn't gone yet this round.
  @floor.each do |row|
    row.each do |current_unit|
      next unless current_unit.is_a? Unit
      next if current_unit.done?
      #print_board @floor
      puts current_unit.inspect

      # Make sure we don't let the same unit move twice in the same tick.
      current_unit.done!
      
      # Look for targets -- live units on the other team
      targets = units.select(&:alive?) \
        .select { |u| u.enemy_of? current_unit }
      
      # If there are no alive enemy targets, my team wins.
      if targets.empty?
        puts
        puts "No enemy units: game over!"
        puts "Rounds completed: #{tick}"
        hp = units.select(&:alive?).map(&:hp).sum
        puts "Total HP remaining on winning team: #{hp}"
        puts "Outcome: #{tick * hp}"
        exit 0
      end
      
      # If no target is adjacent to where I already am, try to move.
      if targets.select { |t| t.adjacent_to? current_unit }.empty?
        
        # Find all reachable squares via breadth-first search.
        reachable = reachable_points current_unit.coordinates
        #puts "  Reachable points:"
        #print_board reachable

        puts "  Trying to move"

        destination = [Float::INFINITY, Float::INFINITY]
        distance = Float::INFINITY
        gunning_for = nil

        # For each target, examine the four adjacent squares. If I can't reach
        # that square (or it's a wall), skip it. Otherwise, check to see if it
        # is closer (or equidistant but better in Reading Order) than my
        # current best guess. If so, select that one and remember what I did.
        targets.each do |t|
          [ [t.x,t.y-1], [t.x-1,t.y], [t.x+1,t.y], [t.x,t.y+1] ].each do |a,b|
            r = reachable[b][a]
            if r.is_a?(Numeric)
              if (r < distance) || # potential square is closer
                 (r == distance && b < destination[1]) || # or equidistant but better in reading order
                 (r == distance && b == destination[1] && a < destination[0])
                destination = [a,b]
                distance = r
                gunning_for = t
                puts "    Picking target at #{gunning_for.coordinates.inspect} destination #{destination.inspect} d:#{distance}"
              end
            end
          end
        end

        # If I didn't find anyone to target, skip the rest of my turn.
        next unless gunning_for

        # Okay, I know where I'm going, the question now is how do I get there.
        # It's likely that there are multiple paths that will get me to the
        # destination, so do a reverse "reachable points" BFS from the
        # destination square (not the enemy) to figure out which paths are the
        # fastest. 
        reverse = reachable_points destination

        # Now pick between them, again looking for the one that is closest (has
        # the lowest distance), breaking ties in reading order.
        destination = [Float::INFINITY, Float::INFINITY]
        distance = Float::INFINITY
        me = current_unit
        [ [me.x,me.y-1], [me.x-1,me.y], [me.x+1,me.y], [me.x,me.y+1] ].each do |a,b|
          r = reverse[b][a]
          if r.is_a? Numeric
            if (r < distance) ||
               (r == distance && b < destination[1]) ||
               (r == distance && b == destination[1] && a < destination[0])
              destination = [a,b]
              distance = r
            end
          end
        end

        # Move there. This involves updating the unit so it knows its new
        # position as well as adjusting the board state to set the old square
        # to nil (empty) and the new square to this unit.
        puts "    Stepping to: #{destination.inspect}"
        x,y = current_unit.coordinates
        @floor[y][x] = nil
        current_unit.move_to destination
        x,y = destination
        @floor[y][x] = current_unit

      end

      # If there is a target adjacent to me, attack them.
      puts "  Trying to attack"
      adjacent_targets = targets.select { |t| t.adjacent_to? current_unit }.sort_by(&:hp)
      if adjacent_targets.any?
        vulnerable_targets = adjacent_targets \
          .select { |t| t.hp == adjacent_targets[0].hp } \
          .sort_by! { |t| t.coordinates.reverse }
        my_target = vulnerable_targets[0]
        puts "    Attacking target #{my_target.inspect}"

        my_target.hurt_by! current_unit

        unless my_target.alive?
          @floor[my_target.y][my_target.x] = nil
          if @part_two && my_target.elf?
            puts "    Tragedy! an elf has died."
            exit 1
          end
        end
        puts "    Result           #{my_target.inspect}"
      else
        puts "    No targets"
      end
    end
  end
  tick += 1
end
