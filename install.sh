#!/bin/bash

# get our working directory straight
cd $(dirname $0)
wd=`pwd`;

# packages to install
packages="git vim tmux tree"

# root no need sudo
if [ `id -u` -ne 0 ]; then 
    sudo="sudo "
else
    sudo=""
fi

# do options
while getopts "dSp:?e" opt; do
    case $opt in
        d)
            deps=1
        ;;
        S)
            sudo=""
        ;;
        p)
            pkg=$OPTARG
        ;;
        e)
            ex_mode=1
         ;;
        ?)
            echo << EOF
Usage: install.sh [-opts]
Options:
    -d              Download and install dependencies
    -S              Dont sudo (when not rooted already)
    -p  pkgmgr      define package manager instead of relying crappy autodetection
    -e              Export mode, download what we can and package it all up.
                        Ignores dependancies, since we cant really know what
                        your target system is like.
EOF
exit 0
        ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
        ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
        ;;
    esac
done

# if -p is not set and we're supposed to install dependencys
# select the most appropriate one
[ -z ${pkg+x} ] && [[ $deps > 0 ]] && { 
    [ -z ${pkg+x} ] && command -v apt-get >/dev/null 2>&1 && { pkg="apt-get"; };
    [ -z ${pkg+x} ] && command -v yum >/dev/null 2>&1 && { pkg="yum"; };
    [ -z ${pkg+x} ] && command -v pkg >/dev/null 2>&1 && { pkg="pkg"; };
}


# install dependencies
[ -z ${deps+x} ] || {
    case $pkg in
        apt-get)
            $sudo$pkg update; $sudo$pkg -y install $packages
        ;;
        yum)
            $sudo$pkg check-update; $sudo$pkg install $packages
        ;;
        pkg) 
            $sudo$pkg install $packages
        ;;
    esac;
};

# check required commands
command -v git >/dev/null 2>&1 || { echo >&2 "git is required, but its not installed. Try running with -d"; exit 1;  }

if [ -z ${ex_mode+x} ]; then

    # download submodules
    git submodule update --init --recursive

    # make dirs'n'files
    mkdir -p ~/.vim/autoload ~/.vim/bundle
    touch ~/.vimrc.local

    # Install pathogen
    cd ~/.vim/autoload
    ln -sfv $wd/vim-pathogen/autoload/pathogen.vim pathogen.vim

    # Install vim plugins
    cd ~/.vim/bundle/
    for d in $wd/vim-plugins/*/; do (ln -svf ${d%*/} ${d##*/}); done

    # Link files to appropriate locations
    cd
    ln -sfv $wd/bash_aliases.bash .bash_aliases
    ln -sfv $wd/inputrc.bash .inputrc
    ln -sfv $wd/vimrc.vim .vimrc
    ln -sfv $wd/vim_help.vim .vim_help
    ln -sfv $wd/tmux.conf .tmux.conf
    ln -sfv $wd/tmux.conf.sh .tmux.conf.sh


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
            cp -f $wd/gitconfig.ini ~/.gitconfig
            echo -e "$content\n$(cat ~/.gitconfig)" > ~/.gitconfig
            echo "Updated gitconfig"
        else
            printf "Adding Git configuration\n"
            read -p "First and last name: " name
            read -p "E-mail address: " email
            cp -f $wd/gitconfig.ini ~/.gitconfig
            user="[user]\n    name = $name\n    email = $email\n"
            echo -e "$user$(cat ~/.gitconfig)" > ~/.gitconfig
        fi
    else
        printf "Adding Git configuration\n"
        read -p "First and last name: " name
        read -p "E-mail address: " email
        cp -f $wd/gitconfig.ini ~/.gitconfig
        user="[user]\n    name = $name\n    email = $email\n"
        echo -e "$user$(cat ~/.gitconfig)" > ~/.gitconfig
    fi

    echo "System files updated!";

else
    echo ""
    
    if [ -f "rc.run" ]; then 
        rm -f rc.run 
    fi
    if [ ! -x "makeself/makeself.sh" ]; then
        git clone https://github.com/megastep/makeself
    fi

    echo "Exporting to rc.run..."
    makeself/makeself.sh --notemp . rc.run "Basic bash settings and programs" echo "Extraction complete! you may now install by running install.sh"

    echo "Export complete!"

fi

