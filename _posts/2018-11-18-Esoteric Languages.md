---
layout: post
author: Andrea Esposito
title: Esoteric Languages
lang: en
categories: [coding]
tags: [coding, hello world, brainfuck, cow]
image: "https://espositoandrea.github.io/assets/images/esoteric-languages.jpg"
---
In this post I'll present you some _esoteric_ programming languages (basically, some "hard-to-read" languages).

For each language, I'll present a block of code that simply outputs "Hello World!" to the screen.

<!--more-->

## Brainfuck

The Brainfuck language is a Turing-Complete language that works using only eight instructions.

The eight instructions of the Brainfuck language are listed below with the 
equivalent instructions in C++, having defined a pointer `unsigned char *ptr`.

| Brainfuck | C++                  |
|-----------|----------------------|
| `>`       | `++ptr`              |
| `<`       | `--ptr`              |
| `+`       | `++(*ptr)`           |
| `-`       | `--(*ptr)`           |
| `.`       | `std::cout << *ptr;` |
| `,`       | `std::cin >> *ptr;`  |
| `[`       | `do {`               |
| `]`       | `} while(*ptr);`     |

The code to output "Hello World!" to the screen is the following.

{% highlight brainfuck %}
++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++. >++.<<+++++++++++++++.>.+++.------.--------.>+.>.
{% endhighlight %}

The code can be splitted in more lines to make it more readable. The same code can
be written and commented like this:

```brainfuck
[
   This program will print "Hello World!" to the screen
]
++++++++++
[
	This loop is used to initialize all values to the nearest multiple of 10 of
	the ASCII values of each letter that will be printed
   >+++++++>++++++++++>+++>+<<<<-
]
>++. print 'H'
>+. print 'e'
+++++++. print 'l'
. print 'l'
+++. print 'o'
>++. print ' ' (space)
<<+++++++++++++++. print 'W'
>. print 'o'
+++. print 'r'
------. print 'l'
--------. print 'd'
>+. print '!'
```

## COW Progamming Language

The COW programming language is a Turing-Complete language, just like Brainfuck.

It has the eleven instructions that are listed below with a small description.
This table is from [bigzaphod's website](https://bigzaphod.github.io/COW/).

| Code | Instruction | Description                                                                                                                                                                                                                                                                                                                     |
|------|-------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 0    | `moo`       | This command is connected to the MOO command. When encountered during normal execution, it searches the program code in reverse looking for a matching MOO command and begins executing again starting from the found MOO command.                                                                                              |
| 1    | `mOo`       | Moves current memory position back one block.                                                                                                                                                                                                                                                                                   |
| 2    | `moO`       | Moves current memory position forward one block.                                                                                                                                                                                                                                                                                |
| 3    | `mOO`       | Execute value in current memory block as if it were an instruction. The command executed is based on the instruction code value (for example, if the current memory block contains a 2, then the moO command is executed). An invalid command exits the running program. Value 3 is invalid as it would cause an infinite loop. |
| 4    | `Moo`       | If current memory block has a 0 in it, read a single ASCII character from STDIN and store it in the current memory block. If the current memory block is not 0, then print the ASCII character that corresponds to the value in the current memory block to STDOUT.                                                             |
| 5    | `MOo`       | Decrement current memory block value by 1.                                                                                                                                                                                                                                                                                      |
| 6    | `MoO`       | Increment current memory block value by 1.                                                                                                                                                                                                                                                                                      |
| 7    | `MOO`       | If current memory block value is 0, skip next command and resume execution after the next matching moo command. If current memory block value is not 0, then continue with next command.                                                                                                                                        |
| 8    | `OOO`       | Set current memory block value to 0.                                                                                                                                                                                                                                                                                            |
| 9    | `MMM`       | If no current value in register, copy current memory block value. If there is a value in the register, then paste that value into the current memory block and clear the register.                                                                                                                                              |
| 10   | `OOM`       | Print value of current memory block to STDOUT as an integer.                                                                                                                                                                                                                                                                    |
| 11   | `oom`       | Read an integer from STDIN and put it into the current memory block.                                                                                                                                                                                                                                                            |

The code to output "Hello World!" to the screen is the following.

{% highlight cpp %}
MoO MoO MoO MoO MoO MoO MoO MoO MoO MoO MOO moO MoO 
MoO MoO MoO MoO MoO MoO moO MoO MoO MoO MoO MoO MoO 
MoO MoO MoO MoO moO MoO MoO MoO moO MoO mOo mOo mOo 
mOo MOo moo moO MoO MoO Moo moO MoO Moo MoO MoO MoO 
MoO MoO MoO MoO Moo Moo MoO MoO MoO Moo moO MoO MoO 
Moo mOo mOo MoO MoO MoO MoO MoO MoO MoO MoO MoO MoO 
MoO MoO MoO MoO MoO Moo moO Moo MoO MoO MoO Moo MOo 
MOo MOo MOo MOo MOo Moo MOo MOo MOo MOo MOo MOo MOo 
MOo Moo moO MoO Moo moO Moo
{% endhighlight %}

The code can be splitted in more lines to make it more readable.

{% highlight cpp %}
MoO MoO MoO MoO MoO MoO MoO MoO MoO MoO 
MOO
   moO MoO MoO MoO MoO MoO MoO MoO moO MoO MoO MoO MoO MoO MoO MoO MoO MoO MoO moO MoO MoO MoO moO MoO mOo mOo mOo mOo MOo 
moo
moO MoO MoO Moo 
moO MoO Moo 
MoO MoO MoO MoO MoO MoO MoO Moo 
Moo 
MoO MoO MoO Moo  
moO MoO MoO Moo 
mOo mOo MoO MoO MoO MoO MoO MoO MoO MoO MoO MoO MoO MoO MoO MoO MoO Moo 
moO Moo 
MoO MoO MoO Moo 
MOo MOo MOo MOo MOo MOo Moo 
MOo MOo MOo MOo MOo MOo MOo MOo Moo 
moO MoO Moo 
moO Moo 
{% endhighlight %}

## Malbolge

This programming language is probably the most difficult one ever created (<abbr
title="In My Humble Opinion">IMHO</abbr>). It takes its name from the eighth
circle of hell in Dante's Inferno. I have to be honest: creating even the
simplest program in this language is impossible. In fact, the first "Hello
World!" was created two years after the creation of this language, and it wasn't
even created by a human: it was generated by a LISP generator/translator. This
language is so hard that we can't even say if it is or if it isn't
Turing-Complete.

By the way, this is the code that outputs "Hello World!".

{% highlight x10 %}
(=<`#9]~6ZY32Vx/4Rs+0No-&Jk)"Fh}|Bcy?`=*z]Kw%oG4UUS0/@-ejc(:'8dc
{% endhighlight %}
