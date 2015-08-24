#Todo list

## Introduction ##

Vtg was born just to explore if libvala can be utilized with some degree of success to implement a symbol completion engine. So **for now** the code is a bit messy and a lot of
refactoring is needed.


## What to do? ##

### Vsc - Vala symbol completion ###

  1. Try to sketch a stable and useful api. At the moment vsc is just an hack with a lot of copy & pasted code all around.
  1. Better type inference for _for_ blocks
  1. Better handling of constructors
  1. Add method parameters info to the result set
  1. Add the ability to produce _calling tooltips_
  1. Add the ability to redirect syantax & parsing error to a Vala.Report class specified by the user of the library

### Vsc-shell - A little interactive shell around Vsc ###

  1. Make the output format more "machine frendly" but still human readable so it can be used by other editors
  1. Implements a little test-suite for Vsc using the shell and some script

### Vtg - the GEdit plugin ###

  * The symbol completion module
    1. Reduce CPU usage
    1. Scheduling a reparse of the _secondary context_ when a file is opened or closed
    1. Better visual information when the vsc cache is rebuilded
    1. Interact with project manager when ready

  * The bracket completion module
    1. use the symbol completion module so we can smart complete some code (eg. array declaration vs array access)
    1. try to not complete inside comments or strings

  * Project manager module
    1. is to be written and used from the other plugins

  * Vala compiler error report
    1. is to be written
