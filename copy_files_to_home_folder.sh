#! /bin/bash

function remove_references {
  [ -f "$1" ] && rm "$1"
  [ -h "$1" ] && rm "$1"
  [ -d "$1" ] && rm -rf "$1"
}

home_files_dir="$(dirname `type -p $0`)/home_files"

if ! echo $home_files_dir | egrep "^/.*" &>/dev/null ; then
  home_files_dir="$(pwd)/${home_files_dir}"
fi

# the special cases
remove_references "$HOME/.ssh/config"
cp $home_files_dir/ssh_config $HOME/.ssh/config

remove_references "$HOME/.matplotlibrc"

if [ -d "$HOME/.matplotlib" ]; then
    remove_references "$HOME/.matplotlib/matplotlibrc"
else
    mkdir "$HOME/.matplotlib"
fi
ln -s $home_files_dir/matplotlibrc "$HOME/.matplotlib/matplotlibrc"


# the rest of the config files
for i in bashrc vimrc gvimrc pythonrc gitconfig dir_colors Xdefaults ackrc \
    gitignore_global noderc coffeerc.coffee jshintrc digrc; do
  remove_references "$HOME/.${i}"
  ln -s $home_files_dir/${i} $HOME/.${i}

  if [ "bashrc" = "$i" ]; then
    source $HOME/.bashrc
  fi
done

