class Grid
  def initialize(dim)
    @dim = dim
    @squares = Array.new((dim+2) * (dim+2), :open)
  end

  def index(x,y)
    x + 1 + ((y+1) * (@dim+2))
  end

  def set(x,y,value)
    @squares[index(x,y)] = value
  end

  def set_index(i,value)
    @squares[i] = value
  end

  def get(x,y)
    @squares[index(x,y)]
  end

  def get_index(i)
    @squares[i]
  end

  def nearby_grid(x,y)
    pts = []
    i = index(x-1,y-1)
    pts += @squares[i..i+2]
    i += @dim + 2
    pts += @squares[i..i+2]
    i += @dim + 2
    pts += @squares[i..i+2]
    pts
  end

  def nearby(x,y)
    counts = { 
      :open => 0,
      :tree => 0,
      :yard => 0,
    }
    pts = []
    i = index(x-1,y-1)
    pts += @squares[i..i+2]
    i += @dim + 2
    pts << @squares[i]
    pts << @squares[i+2]
    i += @dim + 2
    pts += @squares[i..i+2]
    pts.compact.each do |s|
      counts[s] += 1
    end
    counts
  end

  def score
    wood = 0
    yard = 0
    @squares.each do |sq|
      case sq
      when :tree
        wood += 1
      when :yard
        yard += 1
      end
    end
    wood * yard
  end

  def dimensions
    maxy = @squares.size
    maxx = 0
    @squares.each do |row|
      next unless row
      maxx = row.size if row.size > maxx
    end
    [ maxx, maxy ]
  end

  def disp
    puts "-----"
    #print "     "
    #(@dim+2).times do |x|
    #  print (x-1)%10
    #end
    #puts
    #puts
    (@dim+2).times do |y|
      #printf "%4d ", y-1
      (@dim+2).times do |x|
        sq = get(x-1,y-1)
        case sq
        when :open
          print "."
        when :tree
          print "|"
        when :yard
          print "#"
        when NilClass
          print "%"
        else
          raise "unexpected value #{sq}"
        end
      end
      puts
    end
    puts "-----"
  end
end
