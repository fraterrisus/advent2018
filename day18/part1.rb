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

iters.times do
  #this_grid.disp
  dim.times do |y|
    dim.times do |x|
      i = this_grid.index(x,y)
      sq = this_grid.get_index(i)
      n = this_grid.nearby(x,y)
      #puts "(#{x},#{y}) : #{n.inspect}"
      case sq
      when :open
        if n[:tree] > 2
          newval = :tree
        else
          newval = :open
        end
      when :tree
        if n[:yard] > 2
          newval = :yard
        else
          newval = :tree
        end
      when :yard
        if n[:yard] > 0 && n[:tree] > 0
          newval = :yard
        else
          newval = :open
        end
      end
      next_grid.set_index(i,newval)
    end
  end
  tmp = this_grid
  this_grid = next_grid
  next_grid = tmp
end

#this_grid.disp
puts "Score: #{this_grid.score}"
