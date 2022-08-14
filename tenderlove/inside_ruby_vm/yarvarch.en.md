# title YARV Architecture

# set author Japan Ruby Group Koichi Sasada

- 2005-03-03(Thu) 00:31:12 +0900 Various rewrites

---

## This is?

Design notes for [YARV: Yet Another RubyVM][http://www.atdot.net/yarv].

YARV provides the following features for Ruby programs:

- Compiler
- VM Generator

- VMs (Virtual Machines)
- Assembler
- Dis-Assembler
- (experimental) JIT Compiler
- (experimental) AOT Compiler

The current YARV is implemented as an extension library for the Ruby interpreter. child
This allows the necessary functions of the Ruby interpreter (parser, object management, existing
extension library) can be used almost as is.

However, we have to apply some patches to the Ruby interpreter.

In the future, we aim to replace the interpreter part (eval.c) of Ruby itself.
We plan to continue development.

- Compiler (compile.h, compile.c)

The compiler uses the syntax tree (RNode
tree by data) to YARV instruction sequence. YARV instructions are described later.
vinegar.

I didn't do anything particularly difficult, but at the beginning of the scope, etc., the local variables
After that, the syntax tree is followed for conversion.

YARV instruction object and operator
Store the land and finally transform it into a form that can be executed. The compiler will
Managing the memory area generated during compilation can be a problem, but YARV
, this part is very easy because the Ruby interpreter takes care of everything.
(memory is automatically managed by the garbage collector
(because it helps).

All YARV instructions, including identifiers that indicate instructions and operands, are 1 word (
A natural value that can be represented. Pointer size in C language. In Ruby interpreter terms
is the size of VALUE). Therefore, the YARV instruction is a so-called "byte
not "code". For this reason, the term “instruction sequence” is used in explanations of YARV, etc.
I'm using the language

Since it is 1 word, the efficiency of memory utilization is somewhat lower, but the access speed is lower.
Considering these factors, we believe that this method is the best. For example, the operand
It is also possible to store in an instant pool and indicate only the index with an operand.
However, since it becomes an indirect access, it affects the performance, so I rejected it.

- VM Generator (rb/insns2vm.rb, insns.def)

The script rb/insns2vm.rb reads the file insns.def and
Generate the necessary files for the VM. Specifically, replace the part that executes the instructions with
In addition to information necessary for compilation, information necessary for optimization, and
It also generates a file that shows the information necessary for the assembler and disassembler.

## Instruction description

insns.def describes what each instruction is. Specifically:
Describes the information of

- the name of the instruction
- Category of the instruction, comment (English, Japanese)
- the name of the operand
- the value to pop from the stack before executing that instruction
- the value to push onto the stack after executing that instruction
- Logic of the instruction (written in C language)

For example, the instruction putself, which puts self on the stack, is written as follows:
vinegar.

```
#code
/\*_
@c put
@e put self.
Put @j self.
_/
DEFINE_INSN
put self
()
()
(VALUE val)
{
val = GET_SELF();
}
#end
```

In this case there are no operands and no values ​​to pop off the stack. life
After the statement ends, we want to put self on the top of the stack, which is called val.
By assigning it to the variable declared as the value to be pushed onto the stack, this
Translating it produces a C program that sits on the top of the stack.

See the beginning of insns.def for the detailed format. so hard
I do not think.

A file called insnhelper.h contains the macros needed to describe the instruction logic.
is defined. A file called vm.h defines the internal structure of the VM.
located in Le.

- VM (Virtual Machine, vm.h, vm.c)

The VM executes the YARV instruction sequence that is generated as a result of the actual compilation. Masa
In addition, this part becomes the key to YARV, and in the future, replace eval.c with this VM
I would like to.

Anything you can do with your current Ruby interpreter, you can do with this VM
(It's not perfect yet, but it should be).

The VM is implemented as a simple stack machine. stack in one thread
retains one Flexible area because the stack area is taken from the heap
Can be set.

## register

The VM is controlled by 5 virtual registers.

- PC (Program Counter)
- SP (Stack Pointer)
- CFP (Control Frame Pointer)
- LFP (Local Frame Pointer)
- DFP (Dynamic Frame Pointer)

PC indicates the position of the instruction string currently being executed. SP indicates the position of the stack top
increase. CFP, LFP, and DFP indicate frame information respectively. Details will be described later.

## stack frame

obsolete (update soon)

## Supplement about frame design

Considering the Lisp processing system, it is necessary to use block local frames and method
It may seem strange to have something like an extra local frame.
A certain frame is nested, and local variable access is outside the nest.
This is because you can always get there by following the side (that is, you don't need lfp).

But in Ruby things are a little different. First, the method-local information is
There is one thing, specifically the block and self (the receiver from the callee's point of view). child
information in each frame is wasteful.

Also, starting with Ruby2.0, there will be no block-local variables (block-local
The arguments remain, so the structure itself doesn't change much). So the method locale
It is expected that frequent accesses to file variables will occur.

At this time, each access to the method local variable is of the frame (scope)
Decided it was useless to traverse the list and explicitly specified method-local scope and
Separate the block frame and the method local frame from the block frame
is now easily accessible by the lfp register.

## About method call

A method call can be either a method written in YARV instruction sequence or a message written in C.
The dispatch method changes depending on the type.

If it is a YARV instruction sequence, create the stack frame described above and continue the instruction.
increase. In particular, it does not recursively call VM functions.

If it was a method written in C, simply call that function (but
Append the method call information to generate the correct backtrace, then
will do).

For this reason, although we prepared a separate stack for VM, depending on the program,
You may run out of stack (C -> Ruby -> C -> ...
call continues). This is now an unavoidable specification.

## Exception

Exceptions are handled by providing an exception table, similar to Java's JVM. exception
, check the exception table for that frame. Then an exception occurs
If there is an entry that matches the value of the PC when it was generated,
works. If the entry is not found, wrap the stack around and try again.
Inspect the scope's exception table as well.

In addition, break, return (while blocking), retry, etc. are realized by the same mechanism.

### Exception table

Specifically, an exception table entry contains the following information:

- Range of target PCs
- the type of exception to target
- Where to jump if targeted (depending on type)
- iseq of block to fire if targeted

### rescue

The rescue clause is implemented as a block. has the value of $! as its only argument.
vinegar.

```
#code
begin
rescue A
rescue B
rescue C
end
#end
```

is converted to a Ruby script like this:

```
#code
{|err|
case err
when A === err
when B === err
when C === err
else
raise # throw in yarv instruction
end
}
#end
```

### ensure

Normal system (when no exception occurs) and abnormal system (when an exception occurs, etc.)
A sequence of instructions of the type is generated. In a normal system, the code is just a continuous coding region.
compiled. Also, in the abnormal system, it is implemented as a block. always in the end
It ends with a throw instruction.

### break, return (blocking), retry

break statements, return statements in blocks, and retry statements are compiled as throw instructions
will be How far to return is determined by the exception table entry that hooks break.
discontinue.

## Search constant

Despite the name constants, Ruby doesn't determine them at compile time. Or rather,
It is redefinable indefinitely.

The Ruby description for constant access looks like this:

```
#code
Ruby representation:
expr::ID::...::ID
#end
```

This looks like this in the yarv instruction set:

```
#code
(expr)
get constant ID
...
get constant ID
#end
```

### constant search path

If expr is nil , search for constants along the constant search path. this
The behavior may change in the future for Ruby 2.0.

- Trace the dynamic nesting relationship of classes and modules (literally in the program) to the root
- Trace the inheritance relationship to the root (Object)

Therefore, the dynamic nesting of classes and modules must be preserved.
For this purpose, I prepared a thread_object called klass_nest_stack.
This saves the current nesting information.

When defining a method, add (dup) the current nesting information at the time of method definition
This makes it possible to refer to the nesting information when executing the method.
vinegar.

At the top level, there will be no such information.

When the class/module definition statement is executed, the current information itself will be referenced.
increase. This copies that information into the class definition statement when entering the class scope
(Do not do this if already copied).

This enables unified handling of dynamic nesting information.

## optimization method

Since YARV aims to be fast, it utilizes various optimization techniques.
vinegar. I will omit the details, but we have made the following optimizations.

### threaded code

Direct threaded code using labels as values, a C language extension of GCC
is realized.

### Peephole optimization

I'm doing some simple optimizations.

### inline method cache

Embed the method search result in the instruction string.

### inline constant cache

Embed the constant search result in the instruction string.

### Separation of Block and Proc objects

Proc
Don't create it as an object. This eliminates the need for the Proc object
suppressing production.

The Proc method is created when it is actually needed, and at that time the environment (scope
(such as variables allocated on the

### Specialized Instructions

Addition of Fixnums is costly if it is honestly performed by a function call.
Therefore, method calls to perform these primitive operations are dedicated instructions.
I have prepared a decree.

### Command Fusion

Convert multiple instructions into one instruction. Fusion instructions are described in opt_insn_unif.def.
generated automatically.

### Operand fusion

Generate instructions with multiple operands. The fused instructions are in opt_operand.def
Automatically generated by description.

### stack caching

Try to keep the top of the stack in a virtual register. There are currently 2 virtual
It assumes register and does 5-state stack caching. stack cap
Thing instructions are automatically generated.

### JIT Compile

Cut and paste machine language. I only write very experimental code. Ho
Most programs don't work.

### AOT Compile

Convert YARV instruction string to C language. I haven't optimized it enough yet.
It moves quite well. rb/aotc.rb is the compiler.

- Assembler (rb/yasm.rb)

We have prepared an assembler for the YARV instruction sequence. See rb/yasm.rb for usage
(not all of the example generation methods are supported yet).
not).

- Dis-Assembler (disasm.c)

disasm in the object YARVCore::InstructionSequence that indicates the YARV instruction
I have a method. This returns a disassembled string of instructions.

- YARV instruction set

<%=d%>

- others

## test

test/test\_\* are test cases. I'm sure it will work without errors. Conversely,
The example described in this test works just fine.

## Benchmark

Benchmark programs are in benchmark/bm\_\*.

## Future plans

There are still many things to do and many unimplemented parts, so let's do it
I have to go. The biggest goal would be to replace eval.c
mosquito.

### Verifier

The YARV sequence of instructions can be dangerous as it will work even if you make a mistake.
vinegar. For this reason, verification that properly verifies the usage state of the stack in advance
I believe that we must prepare a

### Concept of Compiled File

A data structure serializing a Ruby program to this instruction set to a file
I would like to be able to output Life compiled once using this
If you save the command string in a file, you can save the time and cost of compiling the next time you load it.
can be omitted.

#### overall structure

I'm thinking of the following file structure, but I'm still undecided.

```
#code
u4 : 4-byte unsigned storage
u2 : 2-byte unsigned storage
u1 : 1 byte unsigned storage

every storages are little endian :-)

CompiledFile {
u4 magic;

u2 major;
u2 minor;

u4 character_code;

u4 constants_pool_count;
ConstantEntry constants_pool[constants_pool_count];

u4 block_count;
blockEntry blocks[block_count];

u4 method_count;
MethodEntry methods[method_count];
}
#end
```

A copy of Java classfile.
