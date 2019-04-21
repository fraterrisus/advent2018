#!/usr/bin/env ruby

require './machine.rb'

logfile = File.open("./log", "w")

imem = IO.readlines(ARGV[0]).map(&:chomp)
init = (ARGV[1].nil?) ? 0 : ARGV[1].to_i
machine = Machine.new(init)

md = imem[0].match /#ip\s+(\d+)/
if md
  imem.shift
  machine.ipbind = md[1].to_i
end

print "Minst: "
counter = 0
while instruction = imem[machine.ip]
  tokens = instruction.split /\s+/
  logfile.printf "ip=%04d", machine.ip
  logfile.print " #{machine.registers.inspect} #{instruction}"
  machine.send(tokens[0], tokens[1].to_i, tokens[2].to_i, tokens[3].to_i)
  logfile.puts " #{machine.registers.inspect}"

  counter += 1
  print '.' if counter % 1000000 == 0
  puts if counter % 70000000 == 0
end
puts " #{counter}"
puts "Terminated  #{machine.registers.inspect}"

# I'm one of the people who hates it when AdventOfCode puzzles are
# reverse-engineering puzzles and not programming puzzles. Part 2 runs the same
# program, it just dramatically increases the run time because it runs a nested
# loop with an absurdly large iteration count.
#
# Thanks to the Reddit, I figured out it was doing some sort of factorization
# algorithm. So I figured out the limit, did the factoring myself, added up all
# the factors, and guessed that. Great. Moving on.
