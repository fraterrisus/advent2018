#!/usr/bin/env ruby

require './machine.rb'
machine = Machine.new

lines = IO.readlines('./input-part1.txt').map(&:rstrip)

regstate_matcher = /\[(\d),\s*(\d),\s*(\d),\s*(\d)\]/

opcodes = []
16.times { opcodes << machine.opcodes.dup }

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

  instruction = lines.shift
  after = lines.shift

  md = regstate_matcher.match before
  before = md[1..4].map(&:to_i)
  instruction = instruction.split(/\s+/).map(&:to_i)
  md = regstate_matcher.match after
  after = md[1..4].map(&:to_i)

  puts "------"
  puts "Before:   #{before.inspect}"
  puts "Instr:    #{instruction.inspect}"
  puts "Opcodes:  #{opcodes[instruction[0]].inspect}"
  puts "After:    #{after.inspect}"

  count = 0
  machine.opcodes.each do |op|
    out = before.dup
    machine.public_send(op, out, instruction[1], instruction[2], instruction[3])
    print "  #{op}:   #{out.inspect}"
    if out == after
      puts " +"
    else
      if opcodes[instruction[0]].delete(op)
        puts " - removing"
      else
        puts " -"
      end
    end
  end
  puts "Opcodes:  #{opcodes[instruction[0]].inspect}"
end

puts "------"
puts "Possible matches for each opcode:"
opcodes.each_with_index do |o,i|
  puts "#{i} #{o.inspect}"
end

done = false
until done
  puts "------"
  done = true
  opcodes.each_with_index do |o,i|
    puts "#{i} #{o.inspect}"
    if o.size == 1
      opcodes.each_with_index do |p,j|
        if j != i
          if p.delete(o[0])
            done = false
          end
        end
      end
    end
  end
end

puts "------"
opcodes = opcodes.map { |o| o[0] }
puts opcodes.inspect
puts "------"

lines = IO.readlines('./input-part2.txt').map(&:rstrip)
registers = [0,0,0,0]
while lines.any?
  test = lines.shift.split(/\s+/).map(&:to_i)
  opcode = opcodes[test[0]]
  machine.public_send(opcode, registers, test[1], test[2], test[3])
  puts "#{opcode} #{test[1..3].inspect} -> #{registers.inspect}"
end

