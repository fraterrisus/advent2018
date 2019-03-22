#!/usr/bin/env ruby

freq = 0
freqs = {"0" => true}

lines = IO.readlines(ARGV[0])
while true
  lines.each do |l|
    freq += l.strip.to_i
    if freqs.key?(freq.to_s)
      puts freq
      exit
    else
      freqs[freq.to_s] = true
    end
  end
end
