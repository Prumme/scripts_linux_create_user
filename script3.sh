#!/bin/bash

list=$(sudo find /usr -type f \( -perm -4000 -o -perm -2000 \) -exec ls {} \;)
error_log=()
error=0



if [ -e listFiles ]
then
    
    for file in ${list[@]}
    do
        
        if ! grep -q ${file} listFiles
        then
            error=1
            error_log+=(${file})
            
            if [ $1 = "refill" ]
            then
                echo ${file} >> listFiles
            fi
        fi
        
    done
    
    
else
    touch listFiles
    echo "$list" >> listFiles
fi

if [ $error -eq 1 ]
then
    
    echo "There are at least One modified file since last time: "
    echo ""
    
    for err in ${error_log[@]}
    do
        
        date -r $err
        
    done
fi
