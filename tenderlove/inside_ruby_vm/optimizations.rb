# ruby optimizations.rb | bat

def separator
  puts
  puts
end

puts 'COMPILER OPTIMIZATIONS:'
p RubyVM::InstructionSequence.compile_option
separator

puts 'VM OPTIMIZATIONS:'
p RubyVM::OPTS
separator

puts 'foo.bar'
instructions = RubyVM::InstructionSequence.new <<~EORUBY
  foo.bar
EORUBY
puts instructions.disasm
separator

puts 'foo + bar'
instructions = RubyVM::InstructionSequence.new <<~EORUBY
  foo + bar
EORUBY
puts instructions.disasm
separator
