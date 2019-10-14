#!/bin/sh

DISPLAY_NOTIFICATION(){
~/Library/Application\ Support/NetTester/terminal-notifier.app/Contents/MacOS/terminal-notifier -title "Net Tester"  -message "${MESSAGE}" 
}

old_net=0
net=0

varn=0
while [[ $varn = 0 ]]; do
    
 
    if ping -c 2 google.com >> /dev/null 2>&1; then net=1; else net=0; fi
    
    if [[ ! $old_net = $net ]]; then
    if [[ $net = 0 ]]; then
        MESSAGE="OFFLINE"
     
    else
        MESSAGE="ONLINE"
    fi
    DISPLAY_NOTIFICATION
   
fi
old_net=$net; sleep 2
done

exit

