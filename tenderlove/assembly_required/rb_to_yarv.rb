# ruby -rpp rb_to_asm.rb

def add
  5 + 3
end

instruction_sequence = RubyVM::InstructionSequence.of(method(:add))
# Pretty printer for ruby opbjects: https://github.com/ruby/pp
puts '========== RAW INSTRUCTIONS =========='
pp instruction_sequence.to_a
instructions = instruction_sequence.to_a.last

puts '========== STACK INSTRUCTIONS =========='
stack = []
instructions.each do |insn|
  next unless insn.is_a?(Array)

  case insn
  in [:putobject, v]
    p PUSH: v
    stack << v

  in [:opt_plus, v]
    left = stack.shift
    p POP: left
    right = stack.shift
    p POP: right
    p PUSH: left + right

    stack << left + right

  in [:leave]
    p RETURN: stack.shift

  end
end
