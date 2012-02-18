#!/bin/bash

mvim -o `grep badd devsession.vim | awk '{print $3}' | tr '\n' ' '`
