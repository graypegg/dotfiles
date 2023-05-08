#!/bin/bash

HOME=$XDG_CONFIG_HOME/..

if [ -f "$HOME/.zshrc" ]; then
	DATE=`date +"%s"`
	cp $HOME/.zshrc $HOME/.zshrc.$DATE.backup
	rm $HOME/.zshrc
fi
ln ./.zshrc $HOME/.zshrc
