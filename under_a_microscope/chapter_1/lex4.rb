# ruby lex4.rb

require 'ripper'
require 'pp'

code = <<~STR
  10.times do |n
    puts n
  end
STR

puts code
pp Ripper.lex(code)
