# ruby lex2.rb

require 'ripper'
require 'pp'

code = <<~STR
  10.times do |n|
    puts n/4+6
  end
STR

puts code
pp Ripper.lex(code)
