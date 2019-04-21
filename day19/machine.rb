class Machine

  def initialize(init0)
    @ip = 0
    @ip_bind = nil
    @registers = Array.new(6,0)
    @registers[0] = init0 if init0
  end

  def opcodes
    [:addr, :addi, :mulr, :muli, :banr, :bani, :borr, :bori,
     :setr, :seti, :gtir, :gtri, :gtrr, :eqir, :eqri, :eqrr]
  end

  def ip
    @ip
  end

  def ipbind=(a)
    @ip_bind = a
  end

  def registers
    @registers
  end

  private
  def run_instruction
    if @ip_bind
      @registers[@ip_bind] = @ip
    end
    yield
    if @ip_bind
      @ip = @registers[@ip_bind]
    end
    @ip += 1
  end

  public
  def addr(a, b, c)
    run_instruction { @registers[c] = @registers[a] + @registers[b] }
  end

  def addi(a, b, c)
    run_instruction { @registers[c] = @registers[a] + b }
  end

  def mulr(a, b, c)
    run_instruction { @registers[c] = @registers[a] * @registers[b] }
  end

  def muli(a, b, c)
    run_instruction { @registers[c] = @registers[a] * b }
  end

  def banr(a, b, c)
    run_instruction { @registers[c] = @registers[a] & @registers[b] }
  end

  def bani(a, b, c)
    run_instruction { @registers[c] = @registers[a] & b }
  end

  def borr(a, b, c)
    run_instruction { @registers[c] = @registers[a] | @registers[b] }
  end

  def bori(a, b, c)
    run_instruction { @registers[c] = @registers[a] | b }
  end

  def setr(a, b, c)
    run_instruction { @registers[c] = @registers[a] }
  end

  def seti(a, b, c)
    run_instruction { @registers[c] = a }
  end

  def gtir(a, b, c)
    run_instruction do
      if a > @registers[b]
        @registers[c] = 1
      else
        @registers[c] = 0
      end
    end
  end

  def gtri(a, b, c)
    run_instruction do
      if @registers[a] > b
        @registers[c] = 1
      else
        @registers[c] = 0
      end
    end
  end

  def gtrr(a, b, c)
    run_instruction do
      if @registers[a] > @registers[b]
        @registers[c] = 1
      else
        @registers[c] = 0
      end
    end
  end

  def eqir(a, b, c)
    run_instruction do
      if a == @registers[b]
        @registers[c] = 1
      else
        @registers[c] = 0
      end
    end
  end

  def eqri(a, b, c)
    run_instruction do
      if @registers[a] == b
        @registers[c] = 1
      else
        @registers[c] = 0
      end
    end
  end

  def eqrr(a, b, c)
    run_instruction do
      if @registers[a] == @registers[b]
        @registers[c] = 1
      else
        @registers[c] = 0
      end
    end
  end
end
