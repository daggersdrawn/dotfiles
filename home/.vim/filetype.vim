" my filetype file
if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  au! BufRead,BufNewFile *.rl		setfiletype ragel
  au! BufRead,BufNewFile SCon*		setfiletype scons
  au! BufRead,BufNewFile *.dat		setfiletype ledger
augroup END

