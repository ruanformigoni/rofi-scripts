#!/usr/bin/env bash

#PUT THIS FILE IN ~/.local/share/rofi/finder.sh
#USE: rofi	-show find -modi find:~/.local/share/rofi/finder.sh
baseDir="$HOME"

search_opt(){
	echo -e "! \uf002 Type your search query to find files"
	echo -e "! \uf0f0 You can refine the results typing again"
	echo -e "! \ue7a1 Type ?<string> to ignore the results and make another search"
	echo -e "! \uf1d6 Type ! or nothing to show this message again"
}

search_empty(){
	if [[ ! -z "$1" ]]; then
		echo "$1"
	else
		echo -e "! \uf872 Oh noes! Nothing found'"
		search_opt
	fi
}

search(){
		result=$(locate -i --regexp $1 | sed -e '/\..*\// d' 2>&1)
		search_empty "$result"
	
}

if [ ! -z "$@" ]
then
	QUERY=$@
	if [[ "$@" == /* ]]
	then
		coproc ( exo-open "$@"	> /dev/null 2>&1 )
		exec 1>&-
		exit;
	elif [[ "$@" = \!* ]]
	then
		search_opt
	elif [[ "$@" = \?* ]]
	then
		search "$baseDir.*${QUERY#?}.*" 
	else
		search "$baseDir.*${QUERY#!}.*";
	fi
else
	search_opt
fi
