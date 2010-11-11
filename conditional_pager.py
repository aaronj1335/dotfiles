#! /usr/bin/env python
"""
Read the first line of the pager input, and if it's a git-diff then just output
everything to the screen.  Otherwise use vim as the pager.
"""

import sys, os
from subprocess import Popen, PIPE

if __name__ == '__main__':
    l = sys.stdin.readline()

    if 'diff --git' in l:
        sys.stdout.write(l)
        for l in sys.stdin:
            sys.stdout.write(l)
    else:
        p = Popen(["/bin/sh", "-c", 
            "unset PAGER;col -b -x | \
            vim -R  -c 'set ft=man nomod nolist' \
                    -c 'map q :q<CR>' \
                    -c 'map <SPACE> <C-D>' \
                    -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -"],
            stdin=PIPE)
        p.stdin.write(l)
        p.communicate(sys.stdin.read())