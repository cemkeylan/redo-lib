redo-lib
========

`redo-lib` is a set of helper functions one can incorporate to their source code
to complement the redo build system.

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [redo-lib](#redo-lib)
    - [Installation](#installation)
    - [Using redo-lib](#using-redo-lib)
        - [setv](#setv)
        - [PHONY](#phony)
        - [expsuf](#expsuf)
        - [repsuf](#repsuf)
        - [targcheck](#targcheck)
    - [Copying](#copying)

<!-- markdown-toc end -->


Installation
------------

You can include this library by either copying bits into your `.do` files, or by
copying the file into your repository and calling it from your build files:

``` sh
# It is also sensible to add the library as a dependency as well.
redo-ifchange redo-lib.sh
. ./redo-lib.sh
```


Using redo-lib
--------------

redo-lib saves `$target`, `$basename`, and the `$dest` variables to avoid
depending on positional arguments. `$basename` isn't used internally inside any
functions, but it is set nonetheless. Below are explanations of functions
defined by `redo-lib`.


### setv

`setv()` is similar to how `make` parses variables. You can use operators such
as `+=` or `?=` in order to interact with variables. Here is a real world
example:

``` sh
# Set VERSION
setv VERSION = 1.0

# Set CFLAGS if unset by the user.
setv CFLAGS ?= -std=c99 -Wpedantic -Wall

# Append the following values to CFLAGS
setv CFLAGS += -DVERSION=\"${VERSION}"
```


### PHONY

`PHONY()` acts similar to the `make` `.PHONY:` targets. All it does is basically
setting a trap to remove `$3` on exit. If one or more arguments are given,
`PHONY` will ignore the given targets. If no argument is supplied, PHONY will
ignore the current target.

``` sh
# Ignore non-file targets.
PHONY all install uninstall

# Ignore the current operation.
PHONY

# Ignore the current operation by checking the build target on 'default.do'
case "$1" in
    all)
        redo-ifchange your-program docs/your-documentation.info
        PHONY
        ;;
esac
```

### expsuf

`expsuf()` can be used to add a suffix to the given list. The first argument is
used to store the suffix, and the rest of the arguments are added the suffix.

``` sh
setv BIN = bin/myprog \
           bin/myotherprog
           
setv SRC = $(expsuf .c ${BIN})
```


### repsuf

`repsuf()` can be used to replace the suffix of the given list. The first
argument is used to store the old suffix and the second argument is used to
store the new suffix, and the rest of the arguments are used to replace them.

``` sh
setv SRC = src/myobj.c \
           src/mysecobj.c
           
setv OBJ = $(repsuf .c .o ${SRC})
```

### targcheck

`targcheck()` checks whether the current target is one of the given arguments,
and returns with status 0 on success.

``` sh
# On the file 'clean.do', this will return success
targcheck all clean install

# On the file 'obj.o.do', this will return failure
targcheck obj2.o
```


Copying
-------

This library of helper functions are on the public domain so that anyone willing
to incorporate it into their source code can freely do so.
