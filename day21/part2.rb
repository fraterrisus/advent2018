#!/usr/bin/env ruby

#
# Given that it doesn't make sense for the Halting Problem to have a solution
# unless there's some sort of loop, I figured that I would go back to the
# simulator and print the value of r5 every time we hit instruction 28 until we
# found a loop. That was taking too long, though, so I dropped back to
# examining the trace in part 1 and seeing if I could build a spreadsheet to
# calculate it. A few minutes later I figured out the iteration math, which I
# then reimplemented here along with a lookback checker. Once we find a loop,
# we stop and the answer is the one just before the duplicate.
#

r4 = 0
r5 = 0
seen = []

while true
  r4 = r5 | 65536
  r5 = 13431073

  r5 = r5 + (r4 & 255)
  r5 = r5 & 16777215
  r5 = r5 * 65899
  r5 = r5 & 16777215

  r4 = r4 / 256

  r5 = r5 + (r4 & 255)
  r5 = r5 & 16777215
  r5 = r5 * 65899
  r5 = r5 & 16777215

  r4 = r4 / 256

  r5 = r5 + (r4 & 255)
  r5 = r5 & 16777215
  r5 = r5 * 65899
  r5 = r5 & 16777215

  break if seen.include? r5
  seen << r5
  puts r5
end

