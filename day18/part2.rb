#!/usr/bin/env ruby

require './grid.rb'

iters = ARGV[1].to_i || raise
lines = IO.readlines(ARGV[0]).map(&:rstrip)
dim = lines[0].length
this_grid = Grid.new(dim)
next_grid = Grid.new(dim)
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
    next_grid.set(x,y,val)
  end
end

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
            symbols.each do |f|
              counts[f] += 1
              symbols.each do |g|
                counts[g] += 1
                symbols.each do |h|
                  counts[h] += 1
                  symbols.each do |i|
                    counts[i] += 1

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

                    lookup[[a,b,c,d,e,f,g,h,i]] = newval

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

iters.times do
  #this_grid.disp
  dim.times do |y|
    dim.times do |x|
      newval = lookup[this_grid.nearby_grid(x,y)]
      next_grid.set(x,y,newval)
    end
  end
  tmp = this_grid
  this_grid = next_grid
  next_grid = tmp
end

#this_grid.disp
puts "Score: #{this_grid.score}"
