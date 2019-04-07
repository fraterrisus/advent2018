class Unit

  def initialize(team, x, y, ap)
    @attack_power = ap
    @hit_points = 200
    @team = team
    @x = x
    @y = y
    @turn = false
  end

  def done?
    @turn
  end

  def done!
    @turn = true
  end

  def new_turn
    @turn = false
  end

  def elf?
    @team == :elf
  end

  def goblin?
    @team == :goblin
  end

  def enemy_of?(u)
    @team != u.team
  end

  def adjacent_to?(u)
    adjacent_to_point?(u.x, u.y)
  end

  def adjacent_to_point?(px, py)
    dx = (self.x - px).abs
    dy = (self.y - py).abs

    (dy == 1 && dx == 0) ^ (dx == 1 && dy == 0)
  end

  def alive?
    @hit_points > 0
  end

  def x
    @x
  end

  def y
    @y
  end

  def coordinates
    [@x, @y]
  end

  def move_to(c)
    @x, @y = c
  end

  def hp
    @hit_points
  end

  def ap
    @attack_power
  end

  def hurt_by!(enemy)
    @hit_points -= enemy.ap
  end

  def self.test
    u1 = Unit.new(:elf, 2, 3)
    u2 = Unit.new(:goblin, 2, 4)
    raise unless u1.alive?
    raise unless u2.alive?
    raise unless u1.elf?
    raise if u1.goblin?
    raise unless u2.goblin?
    raise if u2.elf?
    raise unless u1.enemy_of? u2
    raise unless u2.enemy_of? u1
    raise unless u1.adjacent_to? u2
    raise unless u2.adjacent_to? u1
  end

  :protected

  def team
    @team
  end

end
