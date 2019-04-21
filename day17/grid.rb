class Grid
  def initialize
    @squares = []
  end

  def set(x,y,value)
    @squares[y] = [] if @squares[y].nil?
    @squares[y][x] = value
    #puts "Setting (#{x},#{y}) = #{value}"
  end

  def get(x,y)
    if @squares[y].nil?
      nil
    else
      @squares[y][x]
    end
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

  def count_wet(limits)
    cnt = 0
    @squares[limits[2]..limits[3]].each do |row|
      next if row.nil?
      row[limits[0]..limits[1]].each do |sq|
        case sq
        when :wet, :water
          cnt += 1
        end
      end
    end
    cnt
  end

  def count_water(limits)
    cnt = 0
    @squares[limits[2]..limits[3]].each do |row|
      next if row.nil?
      row[limits[0]..limits[1]].each do |sq|
        case sq
        when :water
          cnt += 1
        end
      end
    end
    cnt
  end

  def disp(limits)
    puts "----- #{limits.inspect}"
    @squares[limits[2]..limits[3]].each_with_index do |row,i|
      printf "%4d ", (limits[2] + i)
      if row.nil?
        puts
        next
      end
      col = row[limits[0]..limits[1]]
      if col.nil? || col.empty?
        puts
        next
      end
      col.each do |sq|
        case sq
        when NilClass
          print " "
        when :wet
          print "."
        when :water
          print "~"
        when :clay
          print "#"
        end
      end
      puts
    end
    puts "-----"
  end
end
