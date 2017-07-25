
Naive Command Language
======================

Background
----------

Naive command language (ncl) is a programming language modelling a
primitive register machine with a data stack, both of which are
32-bit wide.

The major motivation is practising the use of GNU flex and bison for
implementing interpreter.

As ncl is extremely primitive and lacks most feature one would
expect (e.g. nested math expression), it could be used as starting
point for exploring implementation of various programming language
constructs.


Language  Description
---------------------

* Stack and registers are 32-bit wide 
* Value of expressions, stack and register data are signed integer
  (Subject to review as it might be difficult to guard overflow)
* Support primitive math expression, using operator + - * /, without
  nested expression (!)
* Looping is done by GOTO LABEL
* A LABEL is given to successfully interpreted statement
* Branch by if-then-else
* Expression value can be pushed onto stack
* Stack top can be pop-ed to register


Possible Futher Exploration
---------------------------
* Add a continuous memory, memory indexing is going to be challenging
* Basic IO, allow read/write to memory
* Add more operations on the data e.g. boolean, bitwise etc


Building
--------

Below tools in cygwin environment are used:

* GNU Make 4.2.1
* gcc 5.4.0
* GNU bison 3.0.4
* flex 2.6.4

To compile, run:

    make ncl

Brief description of file:

* lexer.l, as name
* parser.y, as name
* Makefile, as name
* main.c, entry point
* ncl.[hc], states and operation of ncl machine
