#!/usr/bin/env ruby

lines = IO.readlines(ARGV[0])
num2 = 0
num3 = 0

lines.map(&:strip).each do |l|
  freq = l.chars.inject(Hash.new(0)) { |p,v| p[v] += 1; p }
  counts = freq.values
  num2 += 1 if counts.include? 2
  num3 += 1 if counts.include? 3
end
puts num2 * num3
