#! /bin/bash

function remove_references {
  [ -f "$1" ] && rm "$1"
  [ -h "$1" ] && rm "$1"
  [ -d "$1" ] && rm -rf "$1"
}

function symlink_farm {
  src=$1
  dest=$2
  symlinks=`find $src -type f | grep -Ev '\.sw[op]$'`

  for f in $symlinks; do
    relpath=${f#$src/}
    mkdir -p $dest/`dirname $relpath`
    [ -f $dest/$relpath ] && rm $dest/$relpath
    ln -s $f $dest/$relpath
  done
}

home_files_dir="$(dirname `type -p $0`)/home_files"

# make it an absolute path
if ! echo $home_files_dir | egrep "^/.*" &>/dev/null ; then
  home_files_dir="$(pwd)/${home_files_dir}"
fi

# normalize out any extra ./'s
home_files_dir=`cd $home_files_dir; pwd`

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
    gitignore_global noderc coffeerc.coffee jshintrc repozishrc digrc \
    eslintrc jscsrc timetrap.yml tmux.conf zshrc hgrc; do
  remove_references "$HOME/.${i}"
  ln -s $home_files_dir/${i} $HOME/.${i}

  if [ "bashrc" = "$i" ]; then
    source $HOME/.bashrc
  fi
done

if [ "`uname`" = Linux ]; then
  intellij_dirs="$HOME/.AndroidStudio1.5/config"
elif [ "`uname`" = Darwin ]; then
  intellij_dirs="$HOME/Library/Preferences/AndroidStudio1.5"
fi

for d in $intellij_dirs; do
  symlink_farm $home_files_dir/intellij $d
done
