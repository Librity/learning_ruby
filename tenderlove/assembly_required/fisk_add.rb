# ruby fisk_add.rb | ndisasm -

require 'fisk'

fisk = Fisk.new

# Write 5 to R9
fisk.mov(fisk.r9, fisk.imm(5))

# Write 3 to RAX
fisk.mov(fisk.rax, fisk.imm(3))

# Add R9 to RAX
fisk.add(fisk.rax, fisk.r9)

# Return
fisk.ret

fisk.write_to($stdout)
