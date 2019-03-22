#!/usr/bin/ruby

line = IO.readlines(ARGV[0]).map(&:strip).at(0)
chars = line.split(//)

def react!(chars)
  done = false
  until done
    i = 0
    done = true
    while i+1 < chars.length do
#      print "i=#{i} x=#{chars[i]} y=#{chars[i+1]}"
      this = chars[i]
      that = chars[i+1]
      if this.swapcase == that
#        puts " match, deleting"
        done = false
        chars.delete_at(i)
        chars.delete_at(i)
      else
#        puts
        i += 1
      end
    end
  end
end

map = Hash.new
puts "Original size: #{chars.length}"
puts
('a'..'z').each do |unit|
  print "Filtered out #{unit}: "
  these_chars = chars.find_all { |c| c.downcase != unit }
  print these_chars.length
  react! these_chars
  puts "  Reacted: #{these_chars.length}"
  map[unit] = these_chars.length
end
puts
puts "Minimum: #{map.values.min}"

