#!/bin/bash
# Check current folder
location=`dirname $(realpath $0)`
# Link files to appropriate locations
ln -sfv $location/bash_aliases.bash ~/.bash_aliases
ln -sfv $location/inputrc.bash ~/.inputrc
ln -sfv $location/vimrc.vim ~/.vimrc
ln -sfv $location/vim_help.vim ~/.vim_help
ln -sfv $location/tmux.conf ~/.tmux.conf
ln -sfv $location/tmux.conf.sh ~/.tmux.conf.sh

touch ~/.vimrc.local
# Check if source .bash_aliases already present in .bashrc and add it there if not
check=`grep "bash_aliases" ~/.bashrc`
if [ "$check" ]
then
    echo "Source ~/.bash_aliases already present in .bashrc"
else
    echo "Added source ~/.bash_aliases to .bashrc"
    printf "\n# Source bash aliases\nsource ~/.bash_aliases" >> ~/.bashrc
fi

# Add git configurations to system
if [ -f ~/.gitconfig ]; then
    checkContent=`grep "\[user\]" ~/.gitconfig`
    if [ "$checkContent" ]; then
        content=`head -3 ~/.gitconfig`
        cp -f $location/gitconfig.ini ~/.gitconfig
        echo -e "$content\n$(cat ~/.gitconfig)" > ~/.gitconfig
        echo "Updated gitconfig"
    else
        printf "Adding Git configuration\n"
        read -p "First and last name: " name
        read -p "E-mail address: " email
        cp -f $location/gitconfig.ini ~/.gitconfig
        user="[user]\n    name = $name\n    email = $email\n"
        echo -e "$user$(cat ~/.gitconfig)" > ~/.gitconfig
    fi
else
    printf "Adding Git configuration\n"
    read -p "First and last name: " name
    read -p "E-mail address: " email
    cp -f $location/gitconfig.ini ~/.gitconfig
    user="[user]\n    name = $name\n    email = $email\n"
    echo -e "$user$(cat ~/.gitconfig)" > ~/.gitconfig
fi

echo "System files updated!"
