#! /bin/bash

ss_host=staceserve.dyndns.org
ss_user=astacy
ss="${ss_user}@${ss_host}"

function remove_references {
  [ -f "$1" ] && rm "$1"
  [ -h "$1" ] && rm "$1"
  [ -d "$1" ] && rm "$1"
}

# set up our .vim directory
if [ ! -d ~/.vim ] || [ ! -f ~/.vim/autoload/pathogen.vim ]; then 
	remove_references ~/.vim
	git clone ssh://${ss}/~/repositories/vim-pathogen ~/.vim
	mkdir ~/.vim/bundle
else
	echo "Pulling vim-pathogen"
	( cd ~/.vim && git pull )
fi

bundles="`ssh ${ss} ls repositories | \
		  grep 'vim-' | \
		  grep -v pathogen | \
		  tr '\n' ' '`"

for b in $bundles; do
	if [ -d ~/.vim/bundle/$b ]; then
		echo "Pulling $b"
		( cd ~/.vim/bundle/$b && git pull )
	else
		git clone ssh://${ss}/~/repositories/$b ~/.vim/bundle/$b
	fi
done
