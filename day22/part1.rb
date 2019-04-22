#!/usr/bin/env ruby

# My input: 4848 15 700

depth = ARGV[0].to_i
tx = ARGV[1].to_i
ty = ARGV[2].to_i

geologic_index = []
erosion_level = []

prev_erosion_row = []
(0..ty).each do |y|
  geo_index = y * 48271
  this_index_row = [ geo_index ]
  prev_erosion_value = (geo_index + depth) % 20183
  this_erosion_row = [ prev_erosion_value ]
  (1..tx).each do |x|
    if y == 0
      geo_index = x * 16807
    elsif y == ty && x == tx
      geo_index = 0
    else
      geo_index = prev_erosion_value * prev_erosion_row[x]
    end
    this_index_row << geo_index
    prev_erosion_value = (geo_index + depth) % 20183 
    this_erosion_row << prev_erosion_value
  end
  geologic_index << this_index_row
  erosion_level << this_erosion_row
  prev_erosion_row = this_erosion_row
end

risk_level = 0
region_type = []
(ty+1).times do |y|
  i = erosion_level[y].map { |x| x % 3 }
  region_type << i
  risk_level += i.sum
end

puts "Risk level: #{risk_level}"

=begin
region_type.each do |row|
  row.each do |x|
    case x
    when 0
      print '.'
    when 1
      print '='
    when 2
      print '|'
    end
  end
  puts
end
=end
