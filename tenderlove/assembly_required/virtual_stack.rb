# ruby virtual_stack.rb | ndisasm -

require 'fisk'
require './stack'

def add
  5 + 3
end

instruction_sequence = RubyVM::InstructionSequence.of(method(:add))
instructions = instruction_sequence.to_a.last

stack = Stack.new
fisk = Fisk.new
instructions.each do |insn|
  next unless insn.is_a?(Array)

  case insn
  in [:putobject, v]
    location = stack.push
    fisk.mov(location, fisk.imm(v))

  in [:opt_plus, v]
    left = stack.pop
    right = stack.pop
    fisk.add(left, right)
    location = stack.push
    fisk.mov(location, left)

  in [:leave]
    result = stack.pop
    fisk.mov(fisk.rax, result)
    fisk.ret

  end
end

fisk.write_to($stdout)