" Vim filetype plugin file
" Language:	aaron_note
" Maintainer:	Aaron Stacy <aaron.r.stacy at gmail dot com>
" Last Changed: 2009 Sep 25
" URL:		

if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1

"syntax keyword Day Sun Mon Tue Wed Thu Fri Sat
"highlight Day guifg=grey guibg=darkblue

syntax match Start  "================================================================"
highlight Start guifg=red 
highlight Start ctermfg=red 

syntax region Note  start="----------------------------------------------------------------"  end="----------------------------------------------------------------"
highlight Note guifg=lightgrey 
highlight Note ctermfg=lightgrey 

syntax match End  "----------------------------------------------------------------"
highlight End guifg=blue 
highlight End ctermfg=blue 

syntax match Timestamp  "|  \(Sun\|Mon\|Tue\|Wed\|Thu\|Fri\|Sat\) .*|"
highlight Timestamp guifg=white guibg=darkgrey
highlight Timestamp ctermfg=white ctermbg=darkgrey

