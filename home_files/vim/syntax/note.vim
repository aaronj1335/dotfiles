" Vim filetype plugin file
" Language:	aaron_note
" Maintainer:	Aaron Stacy <aaron.r.stacy at gmail dot com>
" Last Changed: 2010 Nov 11
" URL:

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'note'
endif

if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1

syn region  noteDate    start=+|+  end=+|+ contained
syn region  noteHeader   start=+================================================================================+ end=+--------------------------------------------------------------------------------+ contains=noteDate
syntax match noteEnd  "--------------------------------------------------------------------------------"

if version >= 508 || !exists("did_note_syn_inits")
  if version < 508
    let did_note_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink noteDate Function
  HiLink noteHeader Special
  HiLink noteEnd Special
  HiLink noteDay Error
  delcommand HiLink
endif

let b:current_syntax = "note"
if main_syntax == 'note'
  unlet main_syntax
endif

