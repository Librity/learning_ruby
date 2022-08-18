# ruby -W0 jit_add.rb | ndisasm -

require './jit'

def add
  5 + 3
end

# callable = JIT.new(method(:add)).compile
# define_method :jit_add, &callable
# puts add => jit_add

JIT.new(method(:add)).to_stdout
