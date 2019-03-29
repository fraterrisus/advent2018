#!/usr/bin/env ruby

die unless ARGV[0]
search = ARGV[0].split(//).map(&:to_i)

recipes = [3, 7]
elves = [0, 1]

step = 0
while true do
  # Create new recipes.
  new_recipe = elves.map { |i| recipes[i] }.reduce(&:+)
  tens = new_recipe / 10
  recipes << tens if tens > 0
  recipes << new_recipe % 10

  # Pick new recipes.
  elves.each_with_index do |r,i|
    elves[i] = (r + 1 + recipes[r]) % recipes.size
  end

  # For part 2, we want to check the tail end of the recipes array to see if it
  # matches the desired sequence. We can do that with negative indices in ruby
  # (i.e. -1 is the last entry, -2 is the one before that, etc.)

  #puts "e:#{elves.inspect} r:#{recipes.inspect} s:#{search.inspect}"
  done = true
  search.count.times do |i|
    j = -1 * (i+1)
    if search[j] != recipes[j]
      done = false
      break
    end
  end
  if done
    puts
    puts "Recipes to the left of match: #{recipes.count - search.count}"
    exit
  end

  # Whoops. Sometimes the "create new recipes" section adds two recipes, so we
  # need to also match against the sequence at the end-but-one of the recipes
  # array.
  #
  # This is a kludge and there's almost certainly a way to do it better, but
  # this works.

  done = true
  search.count.times do |i|
    j = -1 * (i+1)
    k = j - 1
    if search[j] != recipes[k]
      done = false
      break
    end
  end
  if done
    puts
    puts "Recipes to the left of match: #{recipes.count - (search.count + 1)}"
    exit
  end

  step += 1
  print "." if step % 10000 == 0
end
