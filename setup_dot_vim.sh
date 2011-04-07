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

bundles="`ssh ${ss} \"ls repositories/vim-*/config; \
		  ls repositories/vim-*/.hg/hgrc \"`"
echo $bundles

for b in $bundles; do
	# each repo is named "vim-<something>" -- store that in $name
	name=`echo $b | egrep -o "repositories/vim-[^/]*" | egrep -o "vim-.*"`
	
	# now set $prog to either git or hg
	prog=git
	if [ "`basename $b`" = "hgrc" ]; then
		prog=hg
	fi

	if [ -d ~/.vim/bundle/$name ]; then
		echo "Pulling $name"
		( cd ~/.vim/bundle/$name && $prog pull )
	else
		$prog clone ssh://${ss}/~/repositories/$name ~/.vim/bundle/$name
	fi
done
