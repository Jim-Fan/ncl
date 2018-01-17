Naive Command Language
======================

Background
----------

Naive command language (ncl) is a programming language modeling an
imaginary machine with a handful of predefined variables ("registers")
and a stack, both of which are 32-bit wide.

The major motivation is practising the use of GNU flex and bison for
implementing interpreter. And when there is need for quick refresh
how they work together, this repo can serve as handy reference.

In early stage, ncl was anticipated to be BASIC-like interpreted
language which is proved to be not-so-trivial to implement. By
making syntax and semantics similar to assembly language, following
difficulties are avoided:

* Syntax tree: each line of ncl code is a represented by a simple 
  C struct
* Symbol table: The only "variables" are 26 pre-defined registers
* Variable scope: The registers are globally available

Despite ncl is an extremely primitive and pathetically impractical,
there is possible room for further extension (see below).


Language  Description
---------------------

* The only data type is 32-bit unsigned integer
* Data stack and registers are 32-bit wide 
* Looping and branching are done by conditional goto


Building
--------

Below tools in cygwin environment are used:

* GNU Make 4.2.1
* gcc 5.4.0
* GNU bison 3.0.4
* flex 2.6.4
* Exuberant Ctags 5.8

To compile, simple run:

    make ncl

Brief description of file:

* lexer.l, as name
* parser.y, as name
* Makefile, as name
* main.c, entry point
* ncl.[hc], states and operation of ncl machine


Possible Further Extension
--------------------------
* Add a continuous memory, support memory indexing and read/write
* Basic IO
* Hex notation
* Bitwise operation
