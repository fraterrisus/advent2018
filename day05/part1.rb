#!/usr/bin/ruby

line = IO.readlines(ARGV[0]).map(&:strip).at(0)
chars = line.split(//)
done = false
until done
  i = 0
  done = true
  while i+1 < chars.length do
    print "i=#{i} x=#{chars[i]} y=#{chars[i+1]}"
    this = chars[i]
    that = chars[i+1]
    if this.swapcase == that
      puts " match, deleting"
      done = false
      chars.delete_at(i)
      chars.delete_at(i)
    else
      puts
      i += 1
    end
  end
end
puts
puts "Remaining size: #{chars.length}"
