#!/usr/bin/ruby

class RangeField
  def initialize
    @ranges = []
  end

  def ranges
    @ranges
  end

  def add_range(r)
    raise ArgumentException unless r.is_a? Range
    add(r.first, r.last)
  end

  def add(first, last)
    n = Range.new(first,last)
    @ranges.each_with_index do |r,i|
      if (c = RangeField.intersection(r,n))
        @ranges[i] = c
        simplify
        return
      end
    end
    @ranges.push n
    simplify
  end

  def self.overlap?(a,b)
    return a.include?(b.first) || a.include?(b.last) || b.include?(a.first) || b.include?(a.last)
  end

  def self.intersection(a,b)
    if self.overlap?(a,b)
      Range.new(
        [ a.first, b.first ].min,
        [ a.last,  b.last  ].max
      )
    else
      nil
    end
  end

  def self.union(a,b)
    if self.overlap?(a,b)
      Range.new(
        [ a.first, b.first ].max,
        [ a.last,  b.last  ].min
      )
    else
      nil
    end
  end


  def self.test
    rf = RangeField.new
    rf.add(4,6)
    rf.add(9,15)
    rf.add(3,5)
    puts rf.ranges
    puts
    rf.add(5,10)
    puts rf.ranges
    puts
    rf.add(1,20)
    puts rf.ranges
  end

  :private

  def simplify
    to_delete = []
    (0..(@ranges.count-2)).each do |i|
      if RangeField.overlap?(@ranges[i], @ranges[i+1])
        @ranges[i+1] = RangeField.intersection(@ranges[i], @ranges[i+1])
        to_delete.unshift i
      end
    end
    to_delete.each do |i|
      @ranges.delete_at(i)
    end
    @ranges.sort_by!(&:first)
  end

end

#RangeField.test
