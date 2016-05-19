#!/bin/bash
# Script to expediently deploy dotfiles in my preferred manner
#
# Typically, I clone this repo down and then replace the local rc files with
# symlinks to the appropriate ones in this repo.  What follows is a needless
# (ab)use of bash arrays, interpolation, and shell arithmetic.

# List of dotfiles to check.  Add new ones here!
declare -a dotfiles=(.bashrc .bash_aliases .vimrc .screenrc)

# This is how I like to organize my git repos:
# ~/git/$SERVER/$PROJECT/$REPO
gitDir=${HOME}/git/github/scellef/personal

# Check if they exist, rename if they do, then deploy the dotfiles
for (( i=0 ; i < ${#dotfiles[@]} ; ++i )) ; do
  if [ ${HOME}/${dotfiles[$i]} ] ; then
    mv ${HOME}/${dotfiles[$i]} ${HOME}/${dotfiles[$i]}.orig # Juuust in case
  fi
  ln -s $gitDir/${dotfiles[$i]} ${HOME}/${dotfiles[$i]}
done
