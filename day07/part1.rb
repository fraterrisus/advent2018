#!/usr/bin/env ruby

lines = IO.readlines(ARGV[0]).map(&:strip)

regex = /Step ([A-Z]) must be finished before step ([A-Z]) can begin\./

parents = {}
('A'..'Z').each { |c| parents[c] = [] }

# Parse out the graph edges. Build a map of node to in-edges, i.e. a list of
# steps that must occur *before* this step can happen.

lines.each do |l|
  matchdata = regex.match l
  raise RuntimeError, "Couldn't match '#{l}'" unless matchdata
  before = matchdata[1]
  after = matchdata[2]
  parents[after] << before
  #puts "#{l} -- #{before} < #{after}"
end

# Search the map of nodes for ones that have no parents, i.e. are able to be
# executed now. Select the lowest alphabetically and insert it into the
# ordering. Then delete it from the map of nodes and from any list of parents
# in which it occurs. Repeat until there are no more nodes.

ordering = []
until parents.empty? do
  heads = parents.select { |k,v| v.empty? }.keys.sort
  #puts heads.inspect
  raise RuntimeError, "Loop detected: no nodes can be run" if heads.empty?
  ordering << heads[0]
  parents.delete heads[0]
  parents.each { |k,v| v.delete heads[0] }
end
puts "Ordering: #{ordering.join ''}"
