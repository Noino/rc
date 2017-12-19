#!/bin/bash
# Update repositories
OS=`cat /etc/issue | grep -io "ubuntu\|debian\|centos"`
os=${OS,,}

# Install required bash cli tools
if [ "$os" == "debian" ] || [ "$os" == "ubuntu" ] ; then
    sudo apt-get update && sudo apt-get -y install git vim tmux tree wget realpath
elif [ "$os" == "centos" ]; then
    sudo yum check-update && sudo yum install git vim tmux tree wget realpath
fi

mkdir -p ~/.vim/autoload ~/.vim/bundle

git submodule update --init --recursive

# Install pathogen package manager for vim
wget -nc -P ~/.vim/autoload/ https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim

# Install vim plugins
for d in vim-plugins/*/; do (ln -fvs $(realpath $d) ~/.vim/bundle/$(basename $d)); done
