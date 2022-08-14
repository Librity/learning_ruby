# ruby strings.rb | bat

def separator
  puts
  puts
end

puts '#{foo}#{bar}'
instructions = RubyVM::InstructionSequence.new <<~EORUBY
  x = "\#{foo}\#{bar}"
EORUBY
puts instructions.disasm
separator

puts 'foo + bar'
instructions = RubyVM::InstructionSequence.new <<~EORUBY
  x = foo + bar
EORUBY
puts instructions.disasm
separator
