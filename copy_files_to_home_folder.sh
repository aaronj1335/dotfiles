#! /bin/bash

function remove_references {
  [ -f "$1" ] && rm "$1"
  [ -h "$1" ] && rm "$1"
  [ -d "$1" ] && rm "$1"
}

remove_references "$HOME/.bashrc"
ln -s $(pwd)/$(dirname $0)/home_files/bashrc $HOME/.bashrc

remove_references "$HOME/.vimrc"
ln -s $(pwd)/$(dirname $0)/home_files/vimrc $HOME/.vimrc

remove_references "$HOME/.gvimrc"
ln -s $(pwd)/$(dirname $0)/home_files/gvimrc $HOME/.gvimrc

remove_references "$HOME/.vim"
ln -s $(pwd)/$(dirname $0)/home_files/vim $HOME/.vim

remove_references "$HOME/.pythonrc"
ln -s $(pwd)/$(dirname $0)/home_files/pythonrc $HOME/.pythonrc

remove_references "$HOME/.ssh/config"
cp $(pwd)/$(dirname $0)/home_files/ssh_config $HOME/.ssh/config

remove_references "$HOME/.gitconfig"
ln -s $(pwd)/$(dirname $0)/home_files/gitconfig $HOME/.gitconfig

remove_references "$HOME/.dir_colors"
ln -s $(pwd)/$(dirname $0)/home_files/dir_colors $HOME/.dir_colors

remove_references "$HOME/.Xdefaults"
ln -s $(pwd)/$(dirname $0)/home_files/Xdefaults $HOME/.Xdefaults

