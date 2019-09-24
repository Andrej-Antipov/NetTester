#!/bin/sh

TITLE="Net Tester"
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
    COMMAND="display notification \"${MESSAGE}\" with title \"${TITLE}\""
    osascript -e "${COMMAND}"
   
fi
old_net=$net; sleep 2
done

exit

