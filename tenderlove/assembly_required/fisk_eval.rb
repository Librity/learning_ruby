# ruby fisk_eval.rb

require 'fisk'
require 'fisk/helpers'

fisk = Fisk.new

fisk.asm do
  mov(r9, imm(5))
  mov(rax, imm(3))
  add(rax, r9)
  ret
end

jit_buffer = Fisk::Helpers.jitbuffer 4096
fisk.write_to jit_buffer
puts jit_buffer.to_function([], Fiddle::TYPE_INT).call

func = jit_buffer.to_function([], Fiddle::TYPE_INT)
define_method :add, &func
puts add
