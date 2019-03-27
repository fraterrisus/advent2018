#!/usr/bin/env ruby
# my puzzle: 464 7173000

require './linknode.rb'



# For part 2, maintaining an array for 7173000 elements is too large. We need
# to break it into smaller arrays, or build a linked list implementation.

num_players = ARGV[0].to_i
last_value = ARGV[1].to_i
die unless num_players
die unless last_value

scores = Array.new(num_players,0)
first_marble = LinkNode.new(0)
last_marble = first_marble
current_marble = first_marble

next_value = 1
current_player = 0

while next_value <= last_value
  if next_value % 23 == 0
    scores[current_player] += next_value
    7.times do
      current_marble = current_marble.prev_or(last_marble)
    end
    scores[current_player] += current_marble.value
    current_marble = current_marble.remove
    first_marble = current_marble if current_marble.first?
  else
    current_marble = current_marble.next_or(first_marble)
    current_marble = current_marble.insert_after(next_value)
    last_marble = current_marble if current_marble.last?
  end

  #puts "[#{current_player+1}] [c:#{current_marble.value}] [f:#{first_marble.value}] #{first_marble.to_s} [l:#{last_marble.value}]"
  #puts "[#{current_player+1}] [#{current_index}] #{marbles.inspect}"
  #print "." if next_value % 1000 == 0

  next_value += 1
  current_player = (current_player + 1) % num_players
end
puts
puts "Winning score: #{scores.max}"
