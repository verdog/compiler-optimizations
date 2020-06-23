# cs6810-compiler-optimizations
# Josh Chandler

## Intro
This is an optimizer created for cs 6810, compiler optimizations, and Western Michigan University. See below for the exact optimizations performed.

## Building

Run the following in the root directory of the repository (the same directory that this README is in):
```bash
make
```

**Sometimes the build process will randomly fail**... probably because of the fact that `make` is configured to build with multiple threads. Just run make again and it should work out.

There are 3 components to this project, and calling `make` will build each one in the following order:
1. The antlr4 runtime library

This is needed for antlr4 to work and has definitions for core antlr4 functionality.

You can find the source code for this portion in [./antlr/lib/antlr4-runtime](./antlr/lib/antlr4-runtime/src). I copied the code from [the official antlr4 repository](https://github.com/antlr/antlr4/tree/master/runtime/Cpp/runtime/src).

2. The parser functions generated by antlr4

This generates the classes such as `ilocBaseVisitor` which I extend.

You can find the grammar file and the generated library in [./antlr/src/parser](./antlr/src/parser). It uses the antlr4 jar file to generate c++ files. The jar file is in [./antlr/lib/](./antlr/lib).

3. My driver and optimizer code

This uses the generated antlr4 code to parse an iloc file, extract basic blocks, apply LVN, global common subexpression elimination, dead code elimination, and register allocation.

The source code for this portion is in [.antlr/src/driver](./antlr/src/driver).

## Scripts

### `iloc.sh`

Once you've built the project, you can use `iloc.sh`, found at the root level of this repository (the same level as this README), to run every `.il` file in `./input` through the optimizer. The optimized files are saved in `./output` as `{filename}.ra.il`. The script first outputs the time it took to optimize each file, and then it outputs the difference between the outputs of the original `.il` file and the optimized `ra.il` file (which should only show a difference in instructions executed).

### `./antlr/quick-test.sh`

This script provides part of the functionality for the master `iloc.sh` script.

It tests the output differences between an unoptimized and optimized `.il` file. 

You must be in the `./antlr` directory to use this script. Usage:
```bash
cd ./antlr # must be here!
quick-test.sh ../input/qs.il # tests qs.il
quick-test.sh # tests all files in ../input
```

## Report

### Optimizations Performed

In the current state of the optimizer, the following optimizations are applied in this order. 

1. Local value numbering
2. Global common subexpression elimination
3. Dead code elimination
4. Global register allocation

You can pick and choose which optimizations to apply when you run the driver:
```bash
# in ./antlr
./driver ../input/qs.il ls # lvn and global common subexpression elimination
./driver ../input/qs.il sd # gcse and dead code elimination
./driver ../input/qs.il lsdr # all optimizations mentioned above.
./driver ../input/qs.il # same as lsdr
```

Dead code elimination and register allocation require the global common subexpression optimization (`s`) to be run before them.

### Register Allocation Details

Register allocation is done with the Chaitin-Briggs bottom up algorithm. Live ranges are computed from SSA, an interference graph is built, and registers are allocated by attempting to color the graph. If the graph can't be colored, uncolored live ranges are spilled and another attempt is made at coloring the graph.

Live ranges are spilled by inserting store instructions after every definition and inserting load instructions before every use. This essentially changes the location of a live range from being in a register to being in a spot in memory. The live ranges are stored on the stack.

Since iloc is pass by reference, an additional step has to be taken when spilling function arguments. Within the function, all arguments are treated as if they are live at all times in live variable analysis until they are spilled. When they are spilled, before each return, they need to be loaded back into their allocated register so that they can be used outside of the function.

### Problems Faced

#### Example Optimized Dynamic and Newdyn

The register allocation process crashes when trying to allocate for `./input/dynamic.lvn.dbre.dce.ruc.il` and `input/newdyn.lvn.dbre.dce.ruc.il`.

#### Pass by Reference and Register Allocation

As mentioned before, since iloc is pass by reference, special cases have to be caught when doing register allocation. 
```
	.frame	quicksort, 8, %vr4, %vr5, %vr6
	
	...

	icall	partition, %vr4, %vr5, %vr6 	 => %vr11
	
	...

	ret
```

In this example, the `quicksort` function takes three arguments. Inside of the function, another function, `partition`, is called. Since iloc is pass by reference, `partition` can (and does) change the contents of some of the arguments. This is fine in iloc, since each argument register is allocated a unique virtual register. But when it comes to register allocation, special care must be taken to make sure the right values are in the right registers upon return from a function.

To model pass by reference from outside of a function, I added lvalues to each call instruction to represent a new definition of the arguments. This made sure that live variable analysis correctly identified the affects of call by reference.

```
icall	partition, %vr4, %vr5, %vr6 	 => %vr11
# can redefine %vr4, %vr5, and %vr6 as well
icall	partition, %vr4, %vr5, %vr6 	 => %vr11, %vr4, %vr5, %vr6
```

From inside of the function, I added a special case to register allocation that considered arguments to always be live until they were spilled. When a function argument is spilled, I make sure that it is re-loaded into the register passed as an argument before any return.

```
.frame quicksort, 36, %vr4, %vr7, %vr6
storeAI %vr4 => %vr0, -36 # vr4 is spilled

...

loadAI %vr0, -36 => %vr4 # make sure vr4 has what it's supposed to have for call by reference before return
ret
```

#### Large Live Ranges and Phi Nodes

To calculate live ranges, I convert the program to SSA form and create a live range for every unique SSA name. I then merge any live ranges that get merged at phi nodes.

This can have bad effects when trying to run register allocation with a very small number of available registers (such as 2). A large live range like this can be made of a number of SSA virtual registers. When spilling a live range like this, the store/load instructions are successfully inserted, but since the live range is made of multiple virtual registers throughout the program, each instance can still interfere with one other live range each. Each of these interferences go back into the original live range, meaning that the graph can't be colored.

I was not able to correct this issue, but I think that creating new live ranges upon spilling might fix it. Creating new live ranges would separate the spread out virtual registers into their own live ranges and reduce interference.

I also tried not counting interferences on live ranges that have already been spilled, but that had unintended consequences that created incorrect optimized code.

#### Malformed Input Iloc

To implement global common subexpression elimination, we need to utilize the fact that in iloc, syntactically equivalent expressions always store into the same register. However, not all input provided actually followed this. For example, while_array.il:

```
...
	testle	%vr7  => %vr8         <--
	cbr	%vr8  -> .L1
.L0:	nop
	loadI	1  => %vr5
	i2i	%vr5  => %vr4
	loadI	10  => %vr6
	comp	%vr4, %vr6 => %vr7
	testgt	%vr7  => %vr8         <--
...
```

These two `test` instructions are actually different operations, but they store into the same register. To address this issue, instead of storing "what defined `%vr8`" when I see it, I store something more like "what *last* defined `%vr8`, and does it exactly match what I'm currently looking at?".

#### Memory Registers VS Expression Registers

Another instance of instructions "breaking" the "syntactic equivalence" rule of iloc are `i2i` instructions. I don't actually believe they're "breaking" the rule, because I remember talking about the distinction between memory and expression registers in class, but it still needed to be accounted for.

This was further complicated by the fact that local value numbering was changing some `i2i` instructions into `loadI` instructions, so they would *appear* to be expression registers, but later be used later as memory registers.

To address this issue, before any optimization pass got to touch the input code, I had another pass go through each instruction and mark it as a memory register or an expression register based on the opcode in used in the instruction that defined it. Then, in my optimizer code, I would never delete instructions that store to a memory register.

After that, I realized that some expressions *used* memory registers as operands and it would sometimes mean I couldn't delete them, even if I had already seen them. The reason I couldn't delete them was the following: because memory registers don't follow the "syntactic equivalence" rule of iloc, a syntactically equivalent expression that used a memory register could still be semantically different.

To address this, when marking registers as memory or expression registers, I introduced a third register type called a "mixed expression" register. A mixed expression register is an expression register that uses memory registers as operands and is not allowed to be deleted.

### Statistics

#### Number of instructions
| File | Original | Optimized - No Register Allocation | 6 registers | 8 registers | 12 registers | 16 registers |
|-|-|-|-|-|-|-|
| `arrayparam.il` | 841 | 474 | 876 | 528 | **474** | **474** |
| `bubble.il` | 4374 | 2761 | 4208 | 3895 | 2832 | **2761** |
| `check.il` | 140 | 5 | **5** | **5** | **5** | **5** |
| `dynamic.il` | 39155 | 24335 | N/A | 31749 | 26107 | 24360 |
| `fib.il` | 274 | 230 | 639 | 537 | **230** | **230** |
| `gcd.il` | 103 | 84 | 170 | 108 | **84** | **84** |
| `newdyn.il` | 136919 | 85151 | 141227 | 117812 | 90527 | **85151** |
| `qs.il` | 4574 | 3464 | N/A | 4982 | 3654 | **3464** |
| `while_array.il` | 377 | 278 | 537 | 339 | **278** | **278** |

#### Optimizer Runtimes
| File | No Register Allocation | 6 registers | 8 registers | 12 registers | 16 registers |
|-|-|-|-|-|-|
| `arrayparam.il` | 0.278s | 0.531s | 0.366s | 0.358s | 0.403s |
| `bubble.il` | 1.013s | 1.943s | 2.024s | 1.904s | 1.634s |
| `check.il` | 0.055s | 0.061s | 0.054s | 0.052s | 0.051s |
| `dynamic.il` | 5.765s | N/A | 9.670s | 11.857s | 12.009s |
| `fib.il` | 0.040s | 0.084s | 0.071s | 0.056s | 0.060s |
| `gcd.il` | 0.096s | 0.277s | 0.217s | 0.163s | 0.143s |
| `newdyn.il` | 2.155s | 4.807s | 4.450s | 4.871s | 3.223s |
| `qs.il` | 0.568s | N/A | 1.471s | 1.346s | 0.959s |
| `while_array.il` | 0.127s | 0.288s | 0.248s | 0.199s | 0.182s |
