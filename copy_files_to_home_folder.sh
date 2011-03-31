#! /bin/bash

function remove_references {
  [ -f "$1" ] && rm "$1"
  [ -h "$1" ] && rm "$1"
  [ -d "$1" ] && rm "$1"
}

for i in bashrc vimrc gvimrc pythonrc gitconfig dir_colors Xdefaults; do
	remove_references "$HOME/.${i}"
	ln -s $(pwd)/$(dirname $0)/home_files/${i} $HOME/.${i}

	if [ "bashrc" = "$i" ]; then
		source $HOME/.bashrc
	fi
done

remove_references "$HOME/.ssh/config"
cp $(pwd)/$(dirname $0)/home_files/ssh_config $HOME/.ssh/config

