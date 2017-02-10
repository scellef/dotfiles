#!/bin/bash
# Script to expediently deploy dotfiles in my preferred manner
#
# Typically, I clone this repo down and then replace the local rc files with
# symlinks to the appropriate ones in this repo.  What follows is a needless
# (ab)use of bash arrays, interpolation, and shell arithmetic.

# List of dotfiles to check.  Add new ones here!
declare -a dotfiles=(.bash_profile .bashrc .bash_aliases .bash_functions .vimrc .screenrc .gitconfig)

# This is how I like to organize my git repos:
# ~/git/$SERVER/$PROJECT/$REPO
gitDir=${HOME}/git/github/scellef/dotfiles

# Make sure gitDir is actually there
if [ ! -d $gitDir ] ; then
  echo "ERROR: $gitDir does not exist."
  exit 1
fi

# I like keeping my vim swap files in one place, rather than littering them everywhere
if [ ! -d ~/.backup ] ; then
  mkdir ~/.backup
fi

# Check if they exist, rename if they do, then deploy the dotfiles
for (( i=0 ; i < ${#dotfiles[@]} ; ++i )) ; do
  timeStamp=$(date +%Y%m%d%H%M%S)
  if [ ${HOME}/${dotfiles[$i]} ] ; then
    # If file is already symlink, just unlink it
    if [ -L ${HOME}/${dotfiles[$i]} ] ; then
      unlink ${HOME}/${dotfiles[$i]}
    # Otherwise, create a timestamped copy of the original file
    else
      mv ${HOME}/${dotfiles[$i]} ${HOME}/${dotfiles[$i]}.$timeStamp 2> /dev/null
      if [ $? -eq 0 ] ; then
        echo "INFO: Copied existing ${dotfiles[$i]} to ${HOME}/${dotfiles[$i]}.$timeStamp"
      fi
    fi
  fi
  ln -s $gitDir/${dotfiles[$i]} ${HOME}/${dotfiles[$i]}
done
