#!/bin/bash

set -e

_toggle_mouse() {
    old=$(tmux show -g | grep mouse | head -n 1 | cut -d' ' -f2)
    new=""

    if [ "$old" = "on" ]; then
      new="off"
    else
      new="on"
    fi

    tmux set -g mouse $new \;\
         display "mouse: $new"
}



