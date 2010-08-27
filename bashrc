alias yo="echo 'screw you i am not a morning person'"
if [[ `uname` == "Darwin" && `whoami` == "aaronj1335" ]]; then

  # Aliases
  alias vip='ssh astacy@msee140lnx10.ecn.purdue.edu'
  alias sftpvip='sftp astacy@msee140lnx10.ecn.purdue.edu'

  alias ashly='ssh ashlystacy@ashly-stacys-macbook.local'
  alias ashlyx='ssh -Y ashlystacy@ashly-stacys-macbook.local'
  alias sftpashly='sftp ashlystacy@ashly-stacys-macbook.local'

  alias arl='ssh stageweb.arlut.utexas.edu'

# this is for ssh-agent authentication
  #alias keyon="ssh-add -t 30800"
  #alias keyon="ssh-add"
  #alias keyoff='ssh-add -D'
  #alias keylist='ssh-add -l'
  #alias pp='ps -jAc'

  export PATH="${PATH}:/usr/local/mysql/bin"

  if [ -f /Applications/MacVim.app/Contents/MacOS/Vim ]; then
    export PATH="/Applications/MacVim.app/Contents/MacOS:$PATH"
  fi

  [ -d $HOME/.cabal/bin ] && export PATH="${PATH}:$HOME/.cabal/bin"

fi

[ -f "$HOME/.ssh-agent" ] && . $HOME/.ssh-agent

[ -d $HOME/downfrom-jmake/bin ] && export PATH="${PATH}:$HOME/downfrom-jmake/bin"

alias ll='lhs -aF'
alias l='ls '

alias gccc='gcc -Wall -ansi'
if [ `uname` == "Linux" ]; then
  export TERM="xterm-color"
  alias ls='ls --color=always'
  alias ll='ls -l '
  alias pp='ps -aux'
fi
if [ `uname` == "SunOS" ]; then
  export TERM="dtterm"
  alias ll='ls -l '
  alias pp='ps -a'
fi

alias grep="grep --color"

if [ `uname` == "Darwin" ]; then
  export TERM="xterm-color"
  alias ll='ls -l '

# to get rid of self-assigned ip:
# sudo ipfw -q flush
fi

if [ "`uname -n`" == "staceserve" ]; then
  export TERM="xterm-color"
  alias ll='ls -l '
fi

alias lp2="lp -o sides=two-sided-long-edge"

# Environment Variables
export PS1="
\[\e[36;1m\]\u\[\e[31m\]@\[\e[32m\]\h\[\e[33m\]:\w     \[\e[35m\]\T \[\e[31m\]\D{%d-%b-%Y}\[\e[0;1m\] 
>>\[\e[0m\] "
export SHELL=${SHELL:-${BASH:-/bin/bash}}
export EDITOR=vim
export PAGER="/bin/sh -c \"unset PAGER;col -b -x | view -c 'set ft=man nomod nolist' -c 'map q :q<CR>' -c 'map <SPACE> <C-D>' -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""

# 1. directories are bold cyan
# 5. executables are red
# 10. and 11. directories that are writable to others are still bolyd cyan,
#             but they have a red background
export LSCOLORS="GxfxcxdxBxegedfbfgGbGb"
export CLICOLOR="true"

set -o emacs

if [ -f ~/.pythonrc ]; then
  export PYTHONSTARTUP="$HOME/.pythonrc"
fi

if [ -f $HOME/.git-completion.sh ]; then
  source $HOME/.git-completion.sh
fi

# check if we're on a UT CS machine
if [ -d $HOME/CS395T/bin ]; then
  export PATH=$HOME/CS395T/bin:$PATH
fi

########################################################################
############       At-Work ssh-agent setup               ###############
########################################################################

# this is for when you're working on many different computers that all
# nfs-mount your home dir

# this shouldn't run if i'm just running a remote command via ssh

#if [ "`tty`" != "not a tty" ]; then
#  ssh_agent_pids="`ps -wef | grep $USER.*ssh-agent | egrep -v grep\|defunct | awk '{print $2}'`"
##echo "\$ssh_agent_pids \"$ssh_agent_pids\""
#  num_ssh_agent_pids=`echo "$ssh_agent_pids" | wc -w`

#  # kill off all ssh-agents that don't correspond to the .ssh-agent-* file
#  if [ -f "$HOME/.ssh-agent-`uname -n`" ]; then
##echo "'.ssh-agent-`uname -n`' is a file"
#    current_ssh_agent_pid_from_file="`grep SSH_AGENT_PID= $HOME/.ssh-agent-$(uname -n)| cut -d';' -f1| cud -d'=' -f2`"
#  else
##echo "'.ssh-agent-`uname -n`' is not a file"
#    current_ssh_agent_pid_from_file=""
#  fi
##echo "\$current_ssh_agent_pid_from_file \"$current_ssh_agent_pid_from_file\""

#  if [ -n "$current_ssh_agent_pid_from_file" ]; then
#    ssh_agent_pids_to_kill="`echo "$ssh_agent_pids"| grep -v $current_ssh_agent_pid_from_file`"
#  else
#    ssh_agent_pids_to_kill="$ssh_agent_pids"
#  fi
##echo "\$ssh_agent_pids_to_kill \"$ssh_agent_pids_to_kill\""
#  [ -n "$ssh_agent_pids_to_kill" ] && kill $ssh_agent_pids_to_kill

#  # now that the extraneous ssh-agent's are dead, get the remaining ssh-agent
#  # pid (if it exists)
#  running_ssh_agent_pid="`ps -wef| grep $USER.*ssh-agent| egrep -v grep\|defunct | awk '{print $2}'`"
##echo "\$running_ssh_agent_pid \"$running_ssh_agent_pid\""

#  if [ "$current_ssh_agent_pid_from_file" != "$running_ssh_agent_pid" ]\
#    || [ -z "$running_ssh_agent_pid" ]; then
#    # if there's a ~/.ssh-agent-<hostname> file, it's invalid since there
#    # aren't any ssh-agent's running, so delete it
#    [ -f $HOME/.ssh-agent-`uname -n` ] && rm $HOME/.ssh-agent-`uname -n`

#    # now start up an ssh-agent and source the env vars
##echo "restarting ssh-agent process"
#    nohup ssh-agent -s | grep -v echo > $HOME/.ssh-agent-`uname -n`
#    source $HOME/.ssh-agent-`uname -n`
#    ssh-add
#  else
##echo "using current ssh-agent process"
#    source $HOME/.ssh-agent-`uname -n`
#  fi
#fi
