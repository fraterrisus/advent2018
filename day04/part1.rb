#!/usr/bin/env ruby

require 'time'

lines = IO.readlines(ARGV[0]).map(&:strip)

guard = 0
old_time = nil
sleep_data = []

lines.each do |l|
  this_time = Time.parse l

  case l
  when /begins shift/
    gn = /\#(\d+)/.match(l)
    raise RuntimeException("No guard number found") if gn.nil?
    guard = gn[1].to_i
    old_time = this_time
    sleep_data[guard] = Array.new(60,0) if sleep_data[guard].nil?
    #puts "Guard #{guard} on shift at #{this_time}"
  when /falls asleep/
    if (old_time.day != this_time.day)
      old_time = Time.new(this_time.year, this_time.month, this_time.day, 0, 0, 0)
    end
    #puts "Guard #{guard} was awake #{old_time} - #{this_time}"
    old_time = this_time
  when /wakes up/
    if (old_time.day != this_time.day)
      old_time = Time.new(this_time.year, this_time.month, this_time.day, 0, 0, 0)
    end
    #puts "Guard #{guard} was asleep #{old_time} - #{this_time}"
    ((old_time.min)...(this_time.min)).each { |m| sleep_data[guard][m] += 1 }
    old_time = this_time
  end
end
puts

# Part 1
guard = 0
max = 0
worst = 0
sleep_data.each_with_index do |data,gid|
  next unless data
  this_sum = data.sum
  if this_sum > max
    guard = gid
    max = this_sum
    worst = data.index(data.max)
  end
end
puts "Guard ##{guard}: total #{max} worst minute #{worst} - hash #{guard * worst}"
puts

# Part 2
guard = 0
minute = 0
worst = 0
sleep_data.each_with_index do |data,gid|
  next unless data
  this_worst = data.max
  if this_worst > worst
    guard = gid
    minute = data.index(this_worst)
    worst = this_worst
  end
end
puts "Guard ##{guard}: worst minute #{minute}, #{worst} times - hash #{guard * minute}"
