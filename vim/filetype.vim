" my filetype file
if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  au! BufRead,BufNewFile *.note.txt   setfiletype note
  au! BufRead,BufNewFile *.note   setfiletype note
augroup END
