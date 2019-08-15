#!/bin/sh

lines=3
col=40

osascript -e "tell application \"Terminal\" to set the font size of window 1 to 12"
osascript -e "tell application \"Terminal\" to set background color of window 1 to {1028, 12850, 33240}"
osascript -e "tell application \"Terminal\" to set normal text color of window 1 to {65535, 65535, 65535}"

clear && printf '\e[8;'${lines}';'$col't' && printf '\e[3J' && printf "\033[H"

printf '\n'

printf "\033[?25l"
printf '   Проверяем интернет соединение ...'


TITLE="Net Tester"
old_net=3
net=0

varn=0
while [[ $varn = 0 ]]; do
    
  
    #if [[ $net = 1 ]]; then
    #for ((i=0; i<2; i++)); do
    #sleep 0.5
    #if ping -c 1 google.com >> /dev/null 2>&1; then net=1; else net=0; fi
    #done
    #else
    if ping -c 1 google.com >> /dev/null 2>&1; then net=1; else net=0; fi
    #fi
    


if [[ ! $old_net = $net ]]; then
old_net=$net
    if [[ $net = 0 ]]; then
        MESSAGE="НЕТ СВЯЗИ"
        printf '\r               \e[33;1m'"$MESSAGE"'              \e[0m\r'
    else
        MESSAGE="СЕТЬ ДОСТУПНА"
        printf '\r             \e[36;1m'"$MESSAGE"'              \e[0m\r'
    fi
    COMMAND="display notification \"${MESSAGE}\" with title \"${TITLE}\""
    osascript -e "${COMMAND}"
fi

read -s -t 1 -n 1 input
if [[ $input = [QqЙй] ]]; then break; fi

done
cat  ~/.bash_history | sed -n '/NetTester/!p' >> ~/new_hist.txt; rm ~/.bash_history; mv ~/new_hist.txt ~/.bash_history
clear
printf "\033[?25h"
osascript -e 'tell application "Terminal" to close first window' & exit

exit

