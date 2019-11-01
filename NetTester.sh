#!/bin/bash

clear && printf '\e[3J' && printf '\033[0;0H'

osascript -e "tell application \"Terminal\" to set the font size of window 1 to 12"
osascript -e "tell application \"Terminal\" to set background color of window 1 to {1028, 12850, 10240}"
osascript -e "tell application \"Terminal\" to set normal text color of window 1 to {65535, 65535, 65535}"


lines=24
printf '\e[8;'${lines}';80t' && printf '\e[3J' && printf "\033[0;0H"

printf "\033[?25l"

printf '\e[2m****************** \e[0m\e[36mПрограмма управления сервисом Net Tester\e[0m\e[2m ********************\e[0m\n'


cd $(dirname $0)

loc=`locale | grep LANG | sed -e 's/.*LANG="\(.*\)_.*/\1/'`
if [[ ! $loc = "ru" ]]; then loc="en"; fi 

EXIT_PROGRAM(){
################################## очистка на выходе #############################################################
cat  ~/.bash_history | sed -n '/NetTesterManager/!p' >> ~/new_hist.txt; rm ~/.bash_history; mv ~/new_hist.txt ~/.bash_history
#####################################################################################################################

     osascript -e 'tell application "Terminal" to close first window' & exit
}



CLEAR_PLACE(){

                    printf "\033[H"
                    printf "\033['$free_lines';0f"
                    printf ' %.0s' {1..80}
                    printf ' %.0s' {1..80}
                    printf ' %.0s' {1..80}
                    printf ' %.0s' {1..80}
                    printf ' %.0s' {1..80}
                    printf ' %.0s' {1..80}
                    printf ' %.0s' {1..80}
                    printf ' %.0s' {1..80}
                    printf ' %.0s' {1..80}
                    printf '\r\033[9A'

}

SET_INPUT(){

layout_name=`defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | egrep -w 'KeyboardLayout Name' | sed -E 's/.+ = "?([^"]+)"?;/\1/' | tr -d "\n"`
xkbs=1

case ${layout_name} in
 "Russian"          ) xkbs=2 ;;
 "RussianWin"       ) xkbs=2 ;;
 "Russian-Phonetic" ) xkbs=2 ;;
 "Ukrainian"        ) xkbs=2 ;;
 "Ukrainian-PC"     ) xkbs=2 ;;
 "Byelorussian"     ) xkbs=2 ;;
 esac

if [[ $xkbs = 2 ]]; then 
cd "$(dirname "$0")"
    if [[ -f "./tools/xkbswitch" ]]; then 
declare -a layouts_names
layouts=`defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleInputSourceHistory | egrep -w 'KeyboardLayout Name' | sed -E 's/.+ = "?([^"]+)"?;/\1/' | tr  '\n' ';'`
IFS=";"; layouts_names=($layouts); unset IFS; num=${#layouts_names[@]}
keyboard="0"

while [ $num != 0 ]; do 
case ${layouts_names[$num]} in
 "ABC"                ) keyboard=${layouts_names[$num]} ;;
 "US Extended"        ) keyboard="USExtended" ;;
 "USInternational-PC" ) keyboard=${layouts_names[$num]} ;;
 "U.S."               ) keyboard="US" ;;
 "British"            ) keyboard=${layouts_names[$num]} ;;
 "British-PC"         ) keyboard=${layouts_names[$num]} ;;
esac

        if [[ ! $keyboard = "0" ]]; then num=1; fi
let "num--"
done

if [[ ! $keyboard = "0" ]]; then ./tools/xkbswitch -se $keyboard; fi
   else
if [[ $loc = "ru" ]]; then        
printf '\r               \e[1;33;5m!!!  Смените раскладку на латиницу   !!!\e[0m               '
else
printf '\r               \e[1;33;5m!!!   Change the layout to Latin     !!!\e[0m               '
fi
read -t 2 -s 
printf '\r                                        \r'
       
 fi
fi
}

GET_INPUT(){
unset inputs
while [[ ! ${inputs} =~ ^[0-4qQa]+$ ]]; do
printf "\033[?25l"
if [[ $loc = "ru" ]]; then             
printf '  Введите символ от \e[1;33m1\e[0m до \e[1;36m4\e[0m, (или \e[1;35mQ\e[0m - выход ):   ' ; printf '                             '
else
printf '  Enter a number from \e[1;33m1\e[0m to \e[1;36m4\e[0m, (or \e[1;35mQ\e[0m - exit ):  ' ; printf '                            '
fi			
printf "%"80"s"'\n'"%"80"s"'\n'"%"80"s"'\n'"%"80"s"
printf "\033[4A"
printf "\r\033[46C"
printf "\033[?25h"
SET_INPUT
read -rsn1 -t1 inputs 
printf "\r"
done
printf "\033[?25l"

}

CHECK_NETTESTER(){

if [[ $(launchctl list | grep "NetTester.job" | cut -f3 | grep -x "NetTester.job") ]]; then  rs_lan="работает"
        else
if [[ ! -f ~/Library/LaunchAgents/NetTester.plist ]]; then rs_lan="не установлен"
            else
                 rs_lan="остановлен"
        fi
fi
}

SHOW_MENU(){

CHECK_NETTESTER

free_lines=16

printf '\e[8;'${lines}';80t' && printf '\e[3J' && printf "\033[0;0H"

printf '\e[2m****************** \e[0m\e[36mПрограмма управления сервисом Net Tester\e[0m\e[2m ********************\e[0m\n'
printf ' %.0s' {1..80}
printf '.%.0s' {1..80}
printf ' %.0s' {1..80}
if [[ $rs_lan = "работает" ]]; then
printf '                   \e[1;32m     Сервис \e[0mNet Tester \e[1;32m'"$rs_lan"'\e[0m                   \n'
else
printf '                   \e[1;33m     Сервис \e[0mNet Tester \e[1;33m'"$rs_lan"'\e[0m                   \n'
fi
printf ' %.0s' {1..80}
printf '.%.0s' {1..80}
printf '\n'
printf ' %.0s' {1..80}
printf '          \e[1;33m1.\e[0m Установить сервис Net Tester                \n'
printf '          \e[1;33m2.\e[0m Остановить                   \n'
printf '          \e[1;33m3.\e[0m Запустить                 \n'
printf '          \e[1;33m4.\e[0m Удалить сервис Net Tester               \n'
printf '          \e[1;35mQ.\e[0m Выйти из программы настройки       \n'
printf ' %.0s' {1..80}
}



######################################## MAIN ##########################################################################################
free_lines=7
var4=0
while [ $var4 != 1 ] 
do
printf '\e[3J' && printf "\033[0;0H" 
printf "\033[?25l"
SHOW_MENU
#SET_INPUT
GET_INPUT

if [[ $inputs = 1 ]]; then
          
            CLEAR_PLACE
            CHECK_NETTESTER
            if [[ ! $rs_lan = "остановлен" ]] || [[ ! $rs_lan = "работает" ]]; then
            if [[ -f tools/NetTester.plist ]] && [[ -f tools/NetTester.sh ]] && [[ -d tools/terminal-notifier.app ]]; then
                if [[ ! -f ~/Library/LaunchAgents/NetTester.plist ]]; then cp -a tools/NetTester.plist ~/Library/LaunchAgents; chmod 755 ~/Library/LaunchAgents/NetTester.plist; fi                
                plutil -remove ProgramArguments.0 ~/Library/LaunchAgents/NetTester.plist
                plutil -insert ProgramArguments.0 -string "/Users/$(whoami)/.NetTester.sh" ~/Library/LaunchAgents/NetTester.plist
                if [[ ! -f ~/.NetTester.sh ]]; then cp -a tools/NetTester.sh ~/.NetTester.sh; chmod u+x ~/.NetTester.sh; fi
                if [[ ! $rs_lan = "работает" ]]; then launchctl load -w ~/Library/LaunchAgents/NetTester.plist; fi
                if [[ ! -d ~/Library/Application\ Support/NetTester ]]; then mkdir  ~/Library/Application\ Support/NetTester; fi
                cp -a tools/terminal-notifier.app ~/Library/Application\ Support/NetTester
        else
        printf '\n   Не найдены файлы для установки. Поместите их в папку tools с установщиком\n'
        printf '\n'
        
        fi
fi

read -n 1 -t 1
CLEAR_PLACE
fi


if [[ $inputs = 2 ]]; then
    CHECK_NETTESTER
    if [[ $rs_lan = "работает" ]]; then
        if [[ -f ~/Library/LaunchAgents/NetTester.plist ]]; then
            launchctl unload -w ~/Library/LaunchAgents/NetTester.plist; fi
        fi
    CLEAR_PLACE
fi

if [[ $inputs = 3 ]]; then
     CHECK_NETTESTER
    if [[ $rs_lan = "остановлен" ]]; then
        if [[ -f ~/Library/LaunchAgents/NetTester.plist ]]; then
            launchctl load -w ~/Library/LaunchAgents/NetTester.plist; fi
        fi
    CLEAR_PLACE
fi

if [[ $inputs = 4 ]]; then
    CHECK_NETTESTER
    if [[ -f ~/.auth/auth.plist ]]; then
        loca=`cat ~/.auth/auth.plist | grep -Eo "Locale"  | tr -d '\n'`
        if [[ $loca = "Locale" ]]; then plutil -remove Locale ~/.auth/auth.plist; fi
    fi
        
    if [[ $(launchctl list | grep "NetTester.job" | cut -f3 | grep -x "NetTester.job") ]]; then launchctl unload -w ~/Library/LaunchAgents/NetTester.plist; fi
    if [[ -f ~/Library/LaunchAgents/NetTester.plist ]]; then rm ~/Library/LaunchAgents/NetTester.plist; fi
    if [[ -f ~/.NetTester.sh ]]; then rm ~/.NetTester.sh; fi
    rm -Rf  ~/Library/Application\ Support/NetTester
    read -n 1 -t 1
    CLEAR_PLACE
fi



if [[ $inputs = [qQ] ]]; then var4=1; fi

done

clear

EXIT_PROGRAM






