# Various helper functions for redo
# URL: https://github.com/cemkeylan/redo-lib
# LICENSE: CC0 (Public Domain)

# 'basename' is not used by the functions here, but it doesn't mean that it
# cannot be used at all.
# shellcheck disable=2034
target=$1 basename=$2 dest=$3

setv() {
    # Usage: setv [variable = [key...]]
    #
    # Variable setting function that somewhat imitates the Makefile syntax.
    # - Using    =   sets the variable.
    # - Using   ?=   sets the variable if it is unset.
    # - Using   +=   increments to a variable.
    [ "$3" ] || {
        printf '%s\n' "Faulty variable syntax" >&2
        exit 1
    }
    var=$1 sym=$2; shift 2
    case "$sym" in
        =)     export "$var=$*" ;;
        \?=)   eval "[ \"\$$var\" ]" || export "$var=$*" ;;
        +=)    eval export "$var=\$$var $*"
    esac
}

targcheck() {
    # Usage: targcheck [target...]
    #
    # Check if current target is one of the given arguments of this function.
    # Returns 0 if target is one of the arguments, returns 1 if not.
    for arg; do
        [ "$arg" = "$target" ] && return 0
    done; return 1
}

PHONY() {
    # Usage: PHONY [target...]
    #
    # Function that resembles the .PHONY: target on the classic 'make' system.
    # You can either use it without an argument on a single target, or specify
    # multiple targets.
    if [ -z "$1" ] || targcheck "$@"; then
        # There is no guarantee that the value of dest will not be modified
        # during the operation, we want to evaluate the value of $dest as soon
        # as possible
        # shellcheck disable=2064
        trap "rm -f $dest" EXIT INT
    fi
}

expsuf() {
    # Usage: expsuf [suffix [item...]]
    #
    # Expand suffix for the given list.
    suffix=$1 buf=; shift
    for i; do buf="$buf $i$suffix "; done; printf %s "$buf"
}

repsuf() {
    # Usage: repsuf [old-suffix new-suffix [item...]]
    #
    # Replace old-suffix with new-suffix on list.
    oldsuffix=$1 newsuffix=$2 buf=; shift 2
    for i; do buf="$buf ${i%$oldsuffix}$newsuffix "; done; printf %s "$buf"
}
