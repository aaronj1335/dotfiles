function EncryptAndExit(password, filename)
  execute "1,$!gpg --symmetric --yes --passphrase ".a:password." -o ".a:filename
  quit!
endfunction

cmap wq<CR> :call<SPACE>EncryptAndExit(password,<SPACE>filename)<CR>
