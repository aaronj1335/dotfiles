#! /bin/bash

if [ "$#" -ne 2 ]; then
	echo "USAGE: $0 <host>"
	exit 1
fi

expect << END_EXPECT
spawn scp .ssh/id_rsa.pub $1:.ssh/authorized_keys
expect "*assword*"
send "1dfR00t!\r"
expect eof
END_EXPECT
echo ""

rsync -aL --progress ~/bin $1:
rsync -aL --progress --exclude '*vim-l9*' --exclude '*vim-fuzzyfinder*' ~/.vim $1:
