Z80 Glue
========

This is the CPLD code which makes my Z80 computer work. It replaces the
many logic chips in the previous incarnation of the Z80 computer.

The project is being documented here: https://hackaday.io/project/21716-z80-computer

Notes
-----

Naming conventions in VHDL.

* _n is for active low
* _i is for an internal signal version of a port 
* c_ is for cookie. I mean, component.
* if it's active low and internal, the order is _n_i
