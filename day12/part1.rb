#!/usr/bin/env ruby

lines = IO.readlines(ARGV[0]).map(&:strip)
generations = ARGV[1].to_i
die if lines.nil?
die if ARGV[1].nil?

# Adds a function to String that converts a string of . and # into an integer
# as if those are binary values (.=0 #=1). This allows us to index
# five-character strings in an array. Is that faster than using a hash? Maybe.
#
# p.s. I hate monkeypatching. But it's very elegant if you're not going to use
# this code anywhere else!

class String
  def to_index
    val = 0
    self.split(//).each_with_index do |c,i|
      if c == '#'
        val += 2 ** i
      end
    end
    val
  end
end

# Initial state is on line 1. Store it in a string.

initial = lines.shift
state = initial.slice(initial.index(/[#.]/), initial.length)
base_pot = 0

# This routine makes room on the left and right sides of the string, in case
# the most extreme # gets too close or too far away from the end. Padding to
# four characters allows us to run the loop in the range [2..x-2] without
# writing extra code. We track how much we've shifted in BASE_POT.
#
# Removing extra space from the left makes sure that the string doesn't grow
# without bound, so iterations stay relatively constant in runtime. It also
# plays a part in steady-state detection.

lroom = state.index('#')
if (lroom < 4)
  state = ('.' * (4-lroom)) + state
  base_pot = base_pot + 4 - lroom
elsif (lroom > 4)
  state = state[(lroom - 4)...(state.size)]
  base_pot = base_pot - lroom + 4
end
rroom = state.size - state.rindex('#')
if (rroom < 4)
  state = state + ('.' * (5-rroom))
end

puts "      start  (#{base_pot}) #{state}"

# Load instructions into a "map" (actually an integer-indexed array), using the
# to_index function we defined above.

map = Array(2**5)
while lines.any?
  l = lines.shift
  next if l.empty?
  tokens = l.split(" => ")
  map[tokens[0].to_index] = tokens[1]
end

# Loop GENERATIONS times. Make a new state vector (string) and iterate over it,
# selecting 5ch substrings, converting them to an index, and indexing into the
# "map" to determine the output character. Then repeat the padding step from
# above.
#
# My first solution stopped there; but then I realized that I had reached a
# steady state after the first thousand iterations and I was going to be here
# for a while waiting for the next 49.999999 billion. So I wrote some code to
# detect a steady state (if the new state vector is the same as the previous
# state except for the base_pot shift), calculate the base_pot delta, and "fast
# forward" through the rest of the iterations to the end.
#
# Naturally, I had a off-by-one error the first time I tried that. *facepalm*

generations.times do |g|

  old_base_pot = base_pot

  new_state = state.dup
  (2..(state.size - 2)).each do |i|
    substr = state[i-2..i+2]
    #puts "  #{substr} -> #{map[substr.to_index]}"
    new_state[i] = map[substr.to_index]
  end

  lroom = new_state.index('#')
  if (lroom < 4)
    new_state = ('.' * (4-lroom)) + new_state
    base_pot = base_pot + 4 - lroom
  elsif (lroom > 4)
    new_state = new_state[(lroom - 4)...(new_state.size)]
    base_pot = base_pot - lroom + 4
  end
  rroom = new_state.size - new_state.rindex('#')
  if (rroom < 4)
    new_state = new_state + ('.' * (5-rroom))
  end

  done = false
  if new_state[0...(state.size)] == state
    puts "states match! fast-forwarding"
    delta = base_pot - old_base_pot
    remaining_generations = generations - (g+1)
    base_pot += delta * remaining_generations
    done = true
  end

  state = new_state
  percent_done = 100.0 * g / generations
  printf "%5.1f%%", percent_done
  puts " done  (#{base_pot}) #{new_state}"

  break if done
end

total = 0
state.split(//).each_with_index do |c,i|
  val = i - base_pot
  total += val if c == '#'
end
puts "Sum of indices of filled pots: #{total}"
