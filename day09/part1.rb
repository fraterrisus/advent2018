#!/usr/bin/env ruby
# my puzzle: 464 71730

# For part 2, maintaining an array for 7173000 elements is too large. We need
# to break it into smaller arrays, or build a linked list implementation.

num_players = ARGV[0].to_i
last_marble = ARGV[1].to_i
die unless num_players
die unless last_marble

scores = Array.new(num_players,0)
marbles = [0]
current_index = 0
next_marble = 1
current_player = 0

while next_marble <= last_marble
  if next_marble % 23 == 0
    scores[current_player] += next_marble
    current_index = (current_index - 7) % marbles.count
    deleted_marble = marbles.delete_at(current_index)
    scores[current_player] += deleted_marble
  else
    current_index = (current_index + 1) % marbles.count
    marbles.insert(current_index + 1, next_marble)
    current_index += 1
  end

  #puts "[#{current_player+1}] [#{current_index}] #{marbles.inspect}"
  print "." if next_marble % 1000 == 0

  next_marble += 1
  current_player = (current_player + 1) % num_players
end
puts
puts "Winning score: #{scores.max}"
