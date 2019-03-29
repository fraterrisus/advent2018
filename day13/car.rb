class Car

  def initialize(track, facing)
    @track = track
    @facing = facing
    @program_idx = 0
    @active = true
  end

  # To advance the car, ask the current Track for the neighbor in the direction
  # that I'm Facing. Once I move there, ask the new Track if I should change my
  # facing. Straight segments keep the same facing; Curves give me a new
  # facing; Intersections say nil, so run my own decision making algorithm.
  def advance
    return unless @active
    @track = @track.next(@facing)
    @facing = @track.new_facing(@facing) || intersection
  end
  
  def track
    @track if @active
  end

  def position
    @track.position if @active
  end

  def y
    self.position[1] if @active
  end

  def x
    self.position[0] if @active
  end

  def active?
    @active
  end

  def deactivate!
    @active = false
  end

  def to_s
    case @facing
    when :north
      '^'
    when :south
      'v'
    when :west
      '<'
    when :east
      '>'
    else
      raise
    end
  end

  :private

  # Here's the decision making algorithm. Iterate between "turn left", "keep
  # this facing", and "turn right". The FACINGS array allows me to add 1 or
  # subtract 1 from my current facing to "turn".

  @@program = [-1, 0, +1]
  @@facings = [:north, :east, :south, :west]

  def intersection
    facing_offset = @@program[@program_idx]
    @program_idx = (@program_idx + 1) % @@program.size
    old_facing_idx = @@facings.index @facing
    new_facing_idx = (old_facing_idx + facing_offset) % @@facings.size
    @facing = @@facings[new_facing_idx]
  end
end
