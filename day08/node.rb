class Node
  def initialize
    @children = []
    @metadata = []
  end

  def children
    @children
  end

  def children=(c)
    @children = c
  end

  def metadata
    @metadata
  end

  def metadata=(m)
    @metadata = m
  end

  def checksum
    @metadata.sum + @children.map(&:checksum).sum
  end

  def value
    if @children.empty?
      @metadata.sum
    else
      v = 0
      @metadata.each do |m|
        n = @children[m-1]
        if n
          v += n.value
        end
      end
      v
    end
  end
end
