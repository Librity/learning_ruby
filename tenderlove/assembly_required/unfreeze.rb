# ruby unfreeze.rb

require 'fiddle'

def unfreeze(str)
  address = Fiddle.dlwrap str
  char_pointer = Fiddle::Pointer.new address
  flags = char_pointer[0, Fiddle::SIZEOF_INT].unpack1('I')
  # Set unfreeze flag to true?
  flags &= ~(1 << 11)
  char_pointer[0, Fiddle::SIZEOF_INT] = [flags].pack('I')
end

x = 'foo'.freeze
puts x.frozen?
unfreeze x
puts x.frozen?
