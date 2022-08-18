# ruby pointer.rb

require 'fiddle'

str = 'hello'.freeze
puts str
# str[0] = 'e'

address = Fiddle.dlwrap str
char_pointer = Fiddle::Pointer.new address
char_pointer[16] = 'e'.bytes.first
puts str
