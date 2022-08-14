# ruby disasm.rb | bat

instructions = RubyVM::InstructionSequence.new <<~EORUBY
  def foo
    "hello "
  end

  puts foo + "world"
EORUBY

puts instructions.disasm
