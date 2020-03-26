#!/usr/bin/env ruby, for proper, sensible OSs;
#Comments!
=begin
Multiline comments!
Ruby: pretty much everything's an object. 

=end
print "I love turtles!"
iMyNum= gets.to_i
print "do you like hoverboards? (0 | 1)"
_HoverBoard1= gets.to_i
puts _HoverBoard1.to_s + " + " + iMyNum.to_s + " = " + (_HoverBoard1+iMyNum).to_s
#puts puts out a new line (\n) whilst print does't. 

#5 arithmetic operators
puts "6 + 4 = " + (6+4).to_s
puts "6 - 4 = " + (6-4).to_s
puts "6 * 4 = " + (6*4).to_s
puts "6 / 4 = " + (6/4).to_s
puts "6 % 4 = " + (6%4).to_s

num_one = 1.9443
fNum = 0.9999 #Needs the 0 before period or returns compilation error
puts num_one.to_s + " + " + fNum.to_s + " = " + (num_one+fNum).to_s
#float w/ standard 14 digits of accuracy when performing operations

puts 1.class
puts 3.141592.class
puts "osmosys is FUN".class

A_CONSTANT = 1234
A_COSNTANT = -42
puts A_CONSTANT
#It will allow us to change a constant's value, but will also return a warning (error?) -> definitely error.

write_handler =File.new("yourSum.out","w")  #creates a local file
write_handler.puts("Random Giberrish").to_s #Writes to it
write_handler.close                         #closes it after we're done with it
data_from_file =File.read("yourSum.out")    #loads data in file to variable
puts "Data from file: " +data_from_file     #prints data from file 
load "file.rb"                              #executes code from another file

#Comparison: == != < > <= >=
#Logical: && || ! and or not
puts "true && false = " + (true && false).to_s
puts "true || false = " + (true || false).to_s
puts "!false = " + (!false).to_s
puts "5 <=> 10" + (5 <=> 10).to_s
=begin
compares a <=> b
if(a==b)
    return 0
elsif(a>b)
    return 1
els        
    return -1
end
=end

age=12
if(age>=5)&& (age<=6)
    puts "get out of here kid"
    puts "You're in kindergarten"
elsif(age>=7)&&(age<=13)
    puts "You're in middle school"
else
    puts "Get a job"
end

unless age>4
    puts "no school boy"
else
    "get yourr ass to school"
end
puts "you're young" if age<30

print "Enter Greeting: "
greeting = gets.chomp   
#gets gets the greeting, chomp gets rid of the new line that the user inputs when he hits enter
case greeting
when "French", "french"
    puts"ouieSuhendeh"
    exit
when "Spanish", "spanish"
    puts "sientate, comprende!"
    exit
else "English"  #the else case substitutes as the default
    puts "Howdy Partner!"
end

#terniary operator, just like JS & C++
puts (age<=50)  ? "OLD" : "YOUNG" 
#first option evaluates as true, second one as false

x=1
loop do
    x+=1 #x++ || x=x+1
    next unless(x % 2)==0
    puts x
    break if x>=10
end #prints all even #s from 1 to 10

y=1
while y<=10
    y+=1
    next unless (y%2)==1
    puts y
end 






return 0