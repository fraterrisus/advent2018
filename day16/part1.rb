#!/usr/bin/env ruby

require './machine.rb'
machine = Machine.new

lines = IO.readlines(ARGV[0]).map(&:rstrip)

regstate_matcher = /\[(\d),\s*(\d),\s*(\d),\s*(\d)\]/

talley = 0
divider = false
while lines.any?
  before = lines.shift

  if before.empty?
    break if divider
    divider = true
    next
  end
  divider = false

  operation = lines.shift
  after = lines.shift

  md = regstate_matcher.match before
  before = md[1..4].map(&:to_i)
  operation = operation.split(/\s+/).map(&:to_i)
  md = regstate_matcher.match after
  after = md[1..4].map(&:to_i)

  puts "------"
  puts "Before:   #{before.inspect}"
  puts "Operation:#{operation.inspect}"
  puts "After:    #{after.inspect}"

  count = 0
  machine.opcodes.each do |op|
    out = before.dup
    machine.public_send(op, out, operation[1], operation[2], operation[3])
    print "  #{op}:   #{out.inspect}"
    if out == after
      puts " match"
      count += 1
      if count >= 3
        talley += 1
        break
      end
    else
      puts
    end
  end
end
puts "------"
puts "Count: #{talley}"

