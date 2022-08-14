# ruby lookup_nil.rb | bat

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
    TABLE[x] || 'omg'.freeze
  end

  table_lookup 'foo'
  table_lookup 'bar'
  table_lookup 'baz'
EORUBY
puts instructions.disasm
separator

puts 'case_lookup 1'
instructions = RubyVM::InstructionSequence.new <<~EORUBY
  def case_lookup x
    case x
    when 'foo' then 'bar'.freeze
    when 'bar' then 'baz'.freeze
    when nil then 'omg'.freeze
    end
  end

  case_lookup 'foo'
  case_lookup 'bar'
  case_lookup 'baz'

EORUBY
puts instructions.disasm
separator

puts 'case_lookup 2'
instructions = RubyVM::InstructionSequence.new <<~EORUBY
  def case_lookup x
    case x
    when nil then 'omg'.freeze
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
