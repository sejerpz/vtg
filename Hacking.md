#Want to hack on Vtg?

## Introduction ##

These are some sparse notes on the project source tree structure.


### Directory structure ###

```
root
 +---- vsc:  static library containing the completion engine
 |
 +---- vsc-shell: unfinished shell useful to debug the
 |                completion engine, but it could be used
 |                to implement Vala completion also in other
 |                editors like emacs, vi etc...
 |
 +---- vtg: the GEdit plugin
```

### Vsc (Vala symbol completion) ###

Is a static library and neither the api nor the abi are
finalized etc etc.

The main concept is that there are 2 code context that are
parsed by a worker thread as needed.

The first one called _primary context_ will go through:

  * the vala parser
  * symbol  resolver
  * semantic analyzer

So its processing will be slower compared to the second one.

The second one called _secondary context_ will go through _only_
the _vala parser_.

This is needed to differentiate the 2 common cases:

  1. source that doesn't change much or at all in a session like vapi files (_primary context_)
  1. source that changes frequently like the current edited buffer and that can contains error etc (_secondary context_)

The engine will try to infere the variable type in the current
buffer and than with that information search for the type definition
first in the secondary context and then in the primary.


### Vsc Shell ###

This program was originally written to quickly prototipe the completion
engine and as an aid to learn libvala internals.

If enhanced can be useful to provide the completion functionality to
other application by issuing command & query on the standard input and
receiving the responses on the standard output in a client / server like
model.

Can be also useful to write a simple set of test script in an hypotetical
test suite for the completion engine.