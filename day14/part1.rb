#!/usr/bin/env ruby

raise unless ARGV[0]
wanted = ARGV[0].to_i
needed = wanted + 10

recipes = [3, 7]
elves = [0, 1]

while recipes.count < needed do
  # Create new recipes.
  new_recipe = elves.map { |i| recipes[i] }.reduce(&:+)
  tens = new_recipe / 10
  recipes << tens if tens > 0
  recipes << new_recipe % 10

  # Pick new recipes.
  elves.each_with_index do |r,i|
    elves[i] = (r + 1 + recipes[r]) % recipes.size
  end

  #puts "e:#{elves.inspect} r:#{recipes.inspect}"
end
puts recipes[wanted...needed].join ''
