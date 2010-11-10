#! /bin/bash

[ -f $HOME/.bashrc ] && rm $HOME/.bashrc
[ -h $HOME/.bashrc ] && rm $HOME/.bashrc
ln -s $(pwd)/$(dirname $0)/bashrc $HOME/.bashrc

[ -f $HOME/.git-completion.sh ] && rm $HOME/.git-completion.sh
[ -h $HOME/.git-completion.sh ] && rm $HOME/.git-completion.sh
ln -s $(pwd)/$(dirname $0)/git-completion.sh $HOME/.git-completion.sh

[ -f $HOME/.vimrc ] && rm $HOME/.vimrc
[ -h $HOME/.vimrc ] && rm $HOME/.vimrc
ln -s $(pwd)/$(dirname $0)/vimrc $HOME/.vimrc

[ -f $HOME/.gvimrc ] && rm $HOME/.gvimrc
[ -h $HOME/.gvimrc ] && rm $HOME/.gvimrc
ln -s $(pwd)/$(dirname $0)/gvimrc $HOME/.gvimrc

[ -f $HOME/.vim ] && rm $HOME/.vim
[ -d $HOME/.vim ] && rm -rf $HOME/.vim
[ -h $HOME/.vim ] && rm -rf $HOME/.vim
ln -s $(pwd)/$(dirname $0)/vim $HOME/.vim

[ -f $HOME/.pythonrc ] && rm $HOME/.pythonrc
[ -h $HOME/.pythonrc ] && rm $HOME/.pythonrc
ln -s $(pwd)/$(dirname $0)/pythonrc $HOME/.pythonrc

[ -f $HOME/.ssh/config ] && rm $HOME/.ssh/config
[ -h $HOME/.ssh/config ] && rm $HOME/.ssh/config
cp $(pwd)/$(dirname $0)/ssh_config $HOME/.ssh/config

[ -f $HOME/.gitconfig ] && rm $HOME/.gitconfig
[ -h $HOME/.gitconfig ] && rm $HOME/.gitconfig
ln -s $(pwd)/$(dirname $0)/gitconfig $HOME/.gitconfig

