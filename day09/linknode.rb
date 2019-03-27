#!/usr/bin/env ruby

class LinkNode
  def initialize(v)
    @prev = nil
    @next = nil
    @value = v
  end

  def value
    @value
  end

  def last?
    self.next.nil?
  end

  def next
    @next
  end

  def next_or(n)
    (self.last?) ? n : self.next
  end
  
  def next=(n)
    @next = n
  end

  def first?
    self.prev.nil?
  end

  def prev
    @prev
  end

  def prev_or(n)
    (self.first?) ? n : self.prev
  end

  def prev=(n)
    @prev = n
  end

  def remove
    self.prev.next = self.next if self.prev
    self.next.prev = self.prev if self.next
    self.next
  end

  def insert_after(v)
    n = LinkNode.new(v)
    n.prev = self
    n.next = self.next
    self.next.prev = n if self.next
    self.next = n
    n
  end

  def to_s
    string = ""
    string += "[" if self.first?
    string += self.value.to_s
    if self.last?
      string += "]"
    else
      string += ","
      string += self.next.to_s
    end
    string
  end
end
