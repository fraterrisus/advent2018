#!/usr/bin/env ruby

require './grid.rb'

iters = ARGV[1].to_i || raise
lines = IO.readlines(ARGV[0]).map(&:rstrip)
dim = lines[0].length
this_grid = Grid.new(dim)
lines.each_with_index do |row,y|
  row.split(//).each_with_index do |sq,x|
    case sq
    when '.'
      val = :open
    when '|'
      val = :tree
    when '#'
      val = :yard
    else
      raise "Unknown char #{sq} at line #{y} char #{x}"
    end
    this_grid.set(x,y,val)
  end
end

# This is a common Game of Life optimization that I played around with after
# finding references online. It helped get the runtime down by about a factor
# of 2. Of course that's nothing compared to the effects we get by adding loop
# detection later on...
#
# The idea is to build a lookup table that you can index on the state of the 9
# nearby squares (including the current square). This is far more efficient
# than computing the new state every time, although the act of looking up the
# neighbors is still significant. I played around with a couple of different
# implementations of the lookup index; a hash of nine symbols was slower than
# the "part 1" implementation, but an array indexed on a constructed integer
# was much faster.

def build_lookup_table
  lookup = Hash.new
  symbols = [:open, :tree, :yard]

  counts = Hash.new
  symbols.each do |s|
    counts[s] = 0
  end

  symbols.each do |a|
    counts[a] += 1
    symbols.each do |b|
      counts[b] += 1
      symbols.each do |c|
        counts[c] += 1
        symbols.each do |d|
          counts[d] += 1
          symbols.each do |e|
            case e
            when :open
              base_value = 0
            when :tree
              base_value = 100
            when :yard
              base_value = 200
            end
            symbols.each do |f|
              counts[f] += 1
              symbols.each do |g|
                counts[g] += 1
                symbols.each do |h|
                  counts[h] += 1
                  symbols.each do |i|
                    counts[i] += 1
                    value = base_value + (counts[:yard] * 10) + counts[:tree]

                    case e
                    when :open
                      if counts[:tree] > 2
                        newval = :tree
                      else
                        newval = :open
                      end
                    when :tree
                      if counts[:yard] > 2
                        newval = :yard
                      else
                        newval = :tree
                      end
                    when :yard
                      if counts[:yard] > 0 && counts[:tree] > 0
                        newval = :yard
                      else
                        newval = :open
                      end
                    end

                    lookup[value] = newval

                    #puts "#{[a,b,c,d,e,f,g,h,i].inspect} #{counts.inspect} #{newval}"

                    counts[i] -= 1
                  end
                  counts[h] -= 1
                end
                counts[g] -= 1
              end
              counts[f] -= 1
            end
          end
          counts[d] -= 1
        end
        counts[c] -= 1
      end
      counts[b] -= 1
    end
    counts[a] -= 1
  end
  lookup
end

lookup = build_lookup_table
grids = []

iters.times do |iter|
  #this_grid.disp
  next_grid = Grid.new(dim)
  dim.times do |y|
    dim.times do |x|
      newval = lookup[this_grid.nearby_value(x,y)]
      next_grid.set(x,y,newval)
    end
  end

  # I admit I had to go look through the Reddit forum to get the hint that the
  # game state would loop back on itself. Then it was just a matter of
  # detecting the loop and using modulo arithmetic to fast-forward to the right
  # state. (and preventing the obvious off-by-one error)

  grids.each_with_index do |g,i|
    if g.eq(next_grid)
      puts "Grid ##{i} matches grid ##{iter}, fast forwarding"
      loop_size = iter - i
      puts "Loop is size #{loop_size}"
      final_index = (((iters - 1) - i) % loop_size) + i
      puts "Iteration #{iters} == #{final_index}"
      this_grid = grids[final_index]
      puts "Score: #{this_grid.score}"
      exit
    end
  end

  grids << next_grid.copy
  this_grid = next_grid
end

#this_grid.disp
puts "Score: #{this_grid.score}"
