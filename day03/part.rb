#!/usr/bin/ruby

require './rangefield.rb'

lines = IO.readlines(ARGV[0]).map(&:strip)
matcher = /\#(\d+)\s*@\s*(\d+),(\d+):\s*(\d+)x(\d+)/

ones = []
twos = []

lines.each do |l|
  md = matcher.match(l)
  next if md.nil?
  id = md[1].to_i
  x1 = md[2].to_i
  y1 = md[3].to_i
  x2 = x1 + md[4].to_i - 1
  y2 = y1 + md[5].to_i - 1
  #puts "(#{x1},#{y1}) - (#{x2},#{y2})"
  new_range = (x1..x2)
  (y1..y2).each do |y|
    #puts "  y=#{y}"
    if (o = ones[y])
      #print "   x1="
      #puts o.ranges.map(&:to_s).join(',')
      o.ranges.each do |r|
        if (new_two = RangeField.union(r,new_range))
          #print "     x2="
          #puts twos[y].ranges.map(&:to_s).join(',')
          #puts "    x2+=#{new_two.to_s}"
          twos[y].add_range(new_two)
          #print "  newx2="
          #puts twos[y].ranges.map(&:to_s).join(',')
        end
      end
    else
      #puts "   x1="
      ones[y] = RangeField.new
      twos[y] = RangeField.new
    end
    ones[y].add_range(new_range)
    #puts "  x1+=#{new_range.to_s}"
    #print "newx1="
    #puts ones[y].ranges.map(&:to_s).join(',')
    #puts
  end
end

sqin = 0
twos.each do |y|
  if y
    y.ranges.each do |r|
      sqin += r.size
    end
  end
end
puts "Total coverage: #{sqin}"

lines.each do |l|
  md = matcher.match(l)
  next if md.nil?
  id = md[1].to_i
  x1 = md[2].to_i
  y1 = md[3].to_i
  x2 = x1 + md[4].to_i - 1
  y2 = y1 + md[5].to_i - 1
  #puts "(#{x1},#{y1}) - (#{x2},#{y2})"
  new_range = (x1..x2)

  shared = false
  (y1..y2).each do |y|
    twos[y].ranges.each do |r|
      if RangeField.overlap?(r,new_range)
        shared = true
        break
      end
      break if shared
    end
    break if shared
  end
  unless shared
    puts "Non-overlapping swatch: #{id}"
    break
  end
end
