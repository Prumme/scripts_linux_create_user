#!/bin/bash
for i in $(cat createUser);
	do
	IFS=':'
	read -ra rows <<< "$i"

	username=${rows[0]}
	firstname=${rows[1]}
	lastname=${rows[2]}
    len=$((${#rows[@]} - 1 ))
    password=${rows[$len]}
    group=${rows[3]}

    if ! grep -q $group /etc/group
        then
            echo "group does not exists."
            sudo groupadd $group
        fi

    if ! grep -q $username /etc/passwd
        then
        sudo useradd  -g $group -p $(openssl passwd -crypt $password) $username
        sudo usermod -c "$firstname $lastname" $username
        sudo mkhomedir_helper $username
        sudo chage -d 0 $username
        


            for ((x=4; x<${#rows[*]}; x++ ))
                do

                if [ $x -ne $len ]
                then

                    if grep -q ${rows[$x]} /etc/group
                    then
                        echo "group exists."
                        sudo usermod -a -G ${rows[$x]} $username

                        else
                        echo "group does not exist."
                        echo ${rows[$x]}
                        sudo groupadd ${rows[$x]}
                        sudo usermod -a -G ${rows[$x]} $username
                    fi
                    # echo "${rows[$x]}"
                    # sudo usermod -a -G ${rows[$x]} $username
                fi

            done 
        loop=$(( $RANDOM % 5 + 4 ))
        for ((x=0; x<$loop; x++ ))
        do
        size=$(( $RANDOM % 50 + 5 + 1 ))
        name="fic$x.text"
        sudo fallocate -l $(($size*1024*1024)) /home/$username/$name

        done
    
     else
        echo "$username already exist"
     fi
done 