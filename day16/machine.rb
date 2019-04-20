class Machine
  def opcodes
    [:addr, :addi, :mulr, :muli, :banr, :bani, :borr, :bori,
     :setr, :seti, :gtir, :gtri, :gtrr, :eqir, :eqri, :eqrr]
  end

  def addr(reg, a, b, c)
    reg[c] = reg[a] + reg[b]
  end

  def addi(reg, a, b, c)
    reg[c] = reg[a] + b
  end

  def mulr(reg, a, b, c)
    reg[c] = reg[a] * reg[b]
  end

  def muli(reg, a, b, c)
    reg[c] = reg[a] * b
  end

  def banr(reg, a, b, c)
    reg[c] = reg[a] & reg[b]
  end

  def bani(reg, a, b, c)
    reg[c] = reg[a] & b
  end

  def borr(reg, a, b, c)
    reg[c] = reg[a] | reg[b]
  end

  def bori(reg, a, b, c)
    reg[c] = reg[a] | b
  end

  def setr(reg, a, b, c)
    reg[c] = reg[a]
  end

  def seti(reg, a, b, c)
    reg[c] = a
  end

  def gtir(reg, a, b, c)
    if a > reg[b]
      reg[c] = 1
    else
      reg[c] = 0
    end
  end

  def gtri(reg, a, b, c)
    if reg[a] > b
      reg[c] = 1
    else
      reg[c] = 0
    end
  end

  def gtrr(reg, a, b, c)
    if reg[a] > reg[b]
      reg[c] = 1
    else
      reg[c] = 0
    end
  end
  
  def eqir(reg, a, b, c)
    if a == reg[b]
      reg[c] = 1
    else
      reg[c] = 0
    end
  end

  def eqri(reg, a, b, c)
    if reg[a] == b
      reg[c] = 1
    else
      reg[c] = 0
    end
  end

  def eqrr(reg, a, b, c)
    if reg[a] == reg[b]
      reg[c] = 1
    else
      reg[c] = 0
    end
  end
end
