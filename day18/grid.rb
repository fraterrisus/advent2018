class Grid
  def initialize
    @squares = []
  end

  def set(x,y,value)
    @squares[y] = [] if @squares[y].nil?
    @squares[y][x] = value
  end

  def get(x,y)
    if x < 0 || y < 0
      nil
    elsif @squares[y].nil?
      nil
    else
      @squares[y][x]
    end
  end

  def nearby(x,y)
    counts = { 
      :open => 0,
      :tree => 0,
      :yard => 0,
    }
    [ [x-1, y-1], [x-1, y], [x-1, y+1], [x, y-1], [x, y+1], [x+1, y-1], [x+1, y], [x+1, y+1] ].each do |a,b|
      s = get(a,b)
      counts[s] += 1 unless s.nil?
    end
    counts
  end

  def score
    wood = 0
    yard = 0
    @squares.each do |row|
      next if row.nil? || row.empty?
      row.each do |sq|
        case sq
        when :tree
          wood += 1
        when :yard
          yard += 1
        end
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

  def disp(limits)
    puts "----- #{limits.inspect}"
    @squares[limits[2]..limits[3]].each_with_index do |row,i|
      printf "%4d ", (limits[2] + i)
      col = row[limits[0]..limits[1]]
      col.each do |sq|
        case sq
        when :open
          print "."
        when :tree
          print "|"
        when :yard
          print "#"
        else
          raise "unexpected value #{sq}"
        end
      end
      puts
    end
    puts "-----"
  end
end
