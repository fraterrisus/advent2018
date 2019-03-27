#!/usr/bin/env ruby

require './node.rb'

@tokens = IO.readlines(ARGV[0]).flat_map { |l| l.split(/\s+/) }.map(&:to_i)

def parse
  # header: (# children) (# metadata)
  n = Node.new
  num_children = @tokens.shift
  num_metadata = @tokens.shift

  # children: recursive parse N times
  my_children = []
  num_children.times do
    my_children << parse
  end
  n.children = my_children
  
  # metadata: N digits
  n.metadata = @tokens.shift(num_metadata)
  return n
end

root = parse
puts "Checksum: #{root.checksum}"
puts "Value: #{root.value}"
