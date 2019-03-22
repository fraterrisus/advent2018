#!/usr/bin/env ruby

freq = 0

IO.readlines(ARGV[0]).each do |l|
  new_freq = l.strip.to_i
  freq += new_freq
end
puts freq
