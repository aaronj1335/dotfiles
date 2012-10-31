#! /bin/bash

ss_host=staceserve.dyndns.org
ss_user=astacy
ss="${ss_user}@${ss_host}"
repo_dir=code

function remove_references {
  [ -f "$1" ] && rm "$1"
  [ -h "$1" ] && rm "$1"
  [ -d "$1" ] && rm "$1"
}

# set up our .vim directory
if [ ! -d ~/.vim ] || [ ! -f ~/.vim/autoload/pathogen.vim ]; then 
	remove_references ~/.vim
	git clone ssh://${ss}/~/$repo_dir/dotvim ~/.vim
	mkdir ~/.vim/bundle
else
	echo "Pulling ~/.vim"
	( cd ~/.vim && git pull )
fi

bundles="`ssh ${ss} ls $repo_dir | \
		  grep 'vim-' | \
		  grep -v pathogen | \
		  tr '\n' ' '`"

bundles="`ssh ${ss} \"ls $repo_dir/vim-*/config; \
		  ls $repo_dir/vim-*/.hg/hgrc \"`"
echo $bundles

for b in $bundles; do
	# each repo is named "vim-<something>" -- store that in $name
	name=`echo $b | egrep -o "$repo_dir/vim-[^/]*" | egrep -o "vim-.*"`
	
	# now set $prog to either git or hg
	prog=git
	if [ "`basename $b`" = "hgrc" ]; then
		prog=hg
	fi

	if [ -d ~/.vim/bundle/$name ]; then
		echo "Pulling $name"
		( cd ~/.vim/bundle/$name && $prog pull )
	else
		$prog clone ssh://${ss}/~/$repo_dir/$name ~/.vim/bundle/$name

		if [ "$name" = "vim-command-t" ]; then
			( cd ~/.vim/bundle/$name && rake make )
		fi
	fi
done
