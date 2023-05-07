#!/bin/bash

HOME=$XDG_CONFIG_HOME/../

if [ -f "$HOME/.p10k.zsh" ]; then
	DATE=`date +"%s"`
	cp $HOME/.p10k.zsh $HOME/.p10k.zsh.$DATE.backup
	rm $HOME/.p10k.zsh
fi
ln ./p10k.zsh $HOME/.p10k.zsh
