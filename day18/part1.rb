#!/usr/bin/env ruby

require './grid.rb'

iters = ARGV[1].to_i || raise
lines = IO.readlines(ARGV[0]).map(&:rstrip)
this_grid = Grid.new
next_grid = Grid.new
maxx = 0
lines.each_with_index do |row,y|
  maxx = row.length if row.length > maxx
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
maxy = lines.count

iters.times do
  #this_grid.disp [0,maxx,0,maxy]
  maxy.times do |y|
    maxx.times do |x|
      sq = this_grid.get(x,y)
      n = this_grid.nearby(x,y)
      #puts "(#{x},#{y}) : #{n.inspect}"
      case sq
      when :open
        if n[:tree] > 2
          next_grid.set(x,y,:tree)
        else
          next_grid.set(x,y,:open)
        end
      when :tree
        if n[:yard] > 2
          next_grid.set(x,y,:yard)
        else
          next_grid.set(x,y,:tree)
        end
      when :yard
        if n[:yard] > 0 && n[:tree] > 0
          next_grid.set(x,y,:yard)
        else
          next_grid.set(x,y,:open)
        end
      end
    end
  end
  tmp = this_grid
  this_grid = next_grid
  next_grid = tmp
end

#this_grid.disp [0,maxx,0,maxy]
puts "Score: #{this_grid.score}"
