# ruby lookup.rb | bat

def separator
  puts
  puts
end

puts 'table_lookup'
instructions = RubyVM::InstructionSequence.new <<~EORUBY
  TABLE = {
    "foo" => 'bar'.freeze,#{' '}
    "bar" => 'baz'.freeze,#{' '}
  }

  def table_lookup x
    TABLE[x]
  end

  table_lookup 'foo'
  table_lookup 'bar'
  table_lookup 'baz'
EORUBY
puts instructions.disasm
separator

puts 'case_lookup'
instructions = RubyVM::InstructionSequence.new <<~EORUBY
  def case_lookup x
    case x
    when 'foo' then 'bar'.freeze
    when 'bar' then 'baz'.freeze
    end
  end

  case_lookup 'foo'
  case_lookup 'bar'
  case_lookup 'baz'

EORUBY
puts instructions.disasm
separator
