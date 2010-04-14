#! /bin/bash

[ -f $HOME/.bashrc ] && rm $HOME/.bashrc
ln -s $(pwd)/$(dirname $0)/bashrc $HOME/.bashrc

[ -f $HOME/.vimrc ] && rm $HOME/.vimrc
ln -s $(pwd)/$(dirname $0)/vimrc $HOME/.vimrc

[ -f $HOME/.vim ] && rm $HOME/.vim
[ -d $HOME/.vim ] && rm -rf $HOME/.vim
ln -s $(pwd)/$(dirname $0)/vim $HOME/.vim

[ -f $HOME/.pythonrc ] && rm $HOME/.pythonrc
ln -s $(pwd)/$(dirname $0)/pythonrc $HOME/.pythonrc

[ -f $HOME/.ssh/id_rsa.pub ] && rm $HOME/.ssh/id_rsa.pub
cp $(pwd)/$(dirname $0)/id_rsa.pub $HOME/.ssh/
