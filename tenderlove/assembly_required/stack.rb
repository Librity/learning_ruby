class Stack
  include Fisk::Registers

  # Max depth: 2
  REGISTERS = [RAX, R9]

  def initialize
    @depth = 0
  end

  def push
    register = REGISTERS.fetch(@depth)
    @depth += 1

    register
  end

  def pop
    @depth -= 1

    REGISTERS.fetch(@depth)
  end
end
