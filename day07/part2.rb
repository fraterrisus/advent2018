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

# Build a list of worker elves. [:index] is just for easier recordkeeping and
# printing of log statements.

workers = Array.new()
(0...5).each do |i|
  workers[i] = { index: i, assignment: nil, complete: nil }
end

timestep = 0
until parents.empty?
  puts "Top of loop (t=#{timestep})"

  # Check all the running workers. If anyone is done, remove the node they were
  # working on from the parent list of any nodes in which it appears and mark
  # this worker idle.

  puts "    Checking running workers"
  workers.select { |w| w[:assignment] }.each do |w|
    if w[:complete] == timestep
      puts "      - #{w.inspect}"
      parents.each { |k,v| v.delete w[:assignment] }
      w[:assignment] = nil
      w[:complete] = nil
    else
      puts "        #{w.inspect}"
    end
  end

  # Check all the idle workers. If any nodes are ready to execute (no longer
  # have any parents), compute the tick at which they will finish and assign
  # the node to this worker. Also remove the node from the parents list so it
  # doesn't get double-assigned. It's okay if we run out of tasks and leave
  # some workers idle.

  puts "    Assigning idle workers"
  workers.select { |w| w[:assignment].nil? }.each do |w|
    heads = parents.select { |k,v| v.empty? }.keys.sort
    if heads.empty?
      puts "        No more ready tasks"
      break
    end
    w[:assignment] = heads[0]
    duration = w[:assignment].ord - 'A'.ord  # A=0  B=1  C=2 etc.
    w[:complete] = timestep + 61 + duration  # A=61 B=62 C=63 etc.
    puts "      + #{w.inspect}"
    parents.delete w[:assignment]
  end

  # We don't have to single-step here, we already know when the next
  # interesting event will happen

  timestep = (workers.map { |w| w[:complete] }.select { |x| x }.min)
end
puts "Finished time: #{timestep}"
