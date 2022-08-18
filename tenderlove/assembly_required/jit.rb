require 'fisk'
require 'fisk/helpers'
require './stack'

# A JIT compiler that can only handle addition.
class JIT
  def initialize(method)
    @stack = Stack.new
    @fisk = Fisk.new
    @method = method
  end

  def compile
    ruby_to_assembly
    assembly_to_fiddle
  end

  def define(name)
    jit_name = "jit_#{name}".to_sym

    define_singleton_method jit_name, &compile
  end

  def to_stdout
    ruby_to_assembly
    fisk.write_to($stdout)
  end

  private

  attr_reader :stack, :fisk, :method

  def ruby_to_assembly
    parse_yarv.each do |instruction|
      next unless instruction.is_a?(Array)

      yarv_to_assembly instruction
    end
  end

  def parse_yarv
    instruction_sequence = RubyVM::InstructionSequence.of(method)

    instruction_sequence.to_a.last
  end

  def assembly_to_fiddle
    jit_buffer = Fisk::Helpers.jitbuffer 4096
    fisk.write_to jit_buffer
    jit_buffer.to_function([], Fiddle::TYPE_INT)
  end

  def yarv_to_assembly(yarv_instruction)
    case yarv_instruction
    in [:putobject, object]
      asm_push object
    in [:opt_plus, _args]
      asm_add
    in [:leave]
      asm_return
    end
  end

  def asm_push(object)
    location = stack.push
    fisk.mov(location, fisk.imm(object))
  end

  def asm_add
    left = stack.pop
    right = stack.pop
    fisk.add(right, left)
    stack.push
  end

  def asm_return
    stack.pop
    fisk.ret
  end
end
