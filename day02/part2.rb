#!/usr/bin/env ruby

lines = IO.readlines("input.txt").map(&:strip)

index = 0
lines.each do |l|
  lines.each do |k|
    base = l.chars
    comp = k.chars

    match = false
    base.each_with_index do |x,i|
      if comp[i] != x
        if match
          match = false
          break
        else
          match = true
          index = i
        end
      end
    end
    if match
      puts base.join('')
      puts comp.join('')
      diff = base.dup
      diff.delete_at(index)
      puts diff.join('')
      exit
    end
  end
end
