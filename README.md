
Naive Command Language
======================

Background
----------

Naive command language (ncl) is a programming language base on a
primitive machine with a handful of registers and a stack, both
of which are 32-bit wide.

The major motivation is practising the use of GNU flex and bison.
As ncl is extremely primitive and lacks most feature one would
expect (e.g. nested math expression), it could be used as starting
point for exploring implementation of various programming language
constructs.

Language  Description
---------------------

* The language operates on a simple stack machine with a handful
  of registers
* Stack and registers are 32-bit width 
* Expression value are either signed integer or register name
* Support primitive math expression, using operator + - * /, without
  nested expression (!)
* Support assignment to registers
* Looping is done by GOTO LABEL
* A LABEL is given to successfully interpreted statement
* Branch by if-then-else
* Expression value can be pushed onto stack
* Stack top can be pop-ed to register

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
