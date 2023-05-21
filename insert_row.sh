#first check if user in DB_admins 
PS3="Please, Choose a Database: "
current=$(whoami)
isexist=$(cat DB_admins.db | grep -w $current | wc -l)
if [[ $isexist -eq 1 ]]
then
    #list DB available and select from them 
    select db in $(ls ./Databases) exit
    do
        #if user chose to exit return to main.sh
        if [[ $db == exit ]]
        then 
            echo "---------------------------------------"
            echo
            PS3="Please, Choose an option: "
            return
        else
            #check if user is the owner then select table 
            owner=$(cat ./Databases/$db/owner.txt)
            if [[ $owner == $current ]]
            then
                PS3="Please, Choose a table: "
                select tbname in $(ls ./Databases/$db/*.table | xargs -n 1 basename) exit
                do
                    #if user chose to exit return to main.sh 
                    if [[ $tbname == exit ]]
                    then
                        echo "---------------------------------------"
                        echo
                        PS3="Please, Choose an option: "
                        return
                    else
                        #create an empty record to append values to it 
                        record=""
                        # get number of columns by getting number of fields
                        numofco=$(awk -F, '{print NF; exit}' ./Databases/$db/$tbname)
                        for index in $(seq 1 ${numofco})
                        do 
                            col=$(head -1 ./Databases/$db/$tbname | cut -d ',' -f$index) #get column name 
                            read -p "Enter a value for column $col: " value
                            # if the index is 1 then it means that it's the PK 
                            #check if PK is duplicate 
                            if [[ index -eq 1 ]]
                            then
                                #pass the value entered as a parameter to awk and return the number of duplicates 
                                duplicate_val=$(cat ./Databases/$db/$tbname | awk -F, -v VAL=$value 'BEGIN {
                                            count=0;
                                        }
                                        {
                                        if ($1 == VAL){ 
                                            count = count +1;
                                            }
                                        
                                        }
                                        END {
                                            print count ;
                                        }'
                                        )
                                 # if duplicate !=0 then it means that the PK is not unique and return to main.sh
                                if [[ $duplicate_val -gt 0 ]]
                                then
                                    echo "Duplicate Primary Key value"
                                    echo "---------------------------------------"
                                    echo
                                    PS3="Please, Choose an option: "
                                    return
                                fi
                            fi
                            #append the values entered to record if PK is unique
                            if [[ $index -eq $numofco ]]
                            then
                                record=$record$value
                            else
                                record=$record$value","
                            fi
                        done
                        # add record to table and return to main.sh
                        echo $record>> ./Databases/$db/$tbname
                        echo "Row was inserted Successfully "
                        echo "---------------------------------------"
                        echo
                        PS3="Please, Choose an option: "
                        return
                    fi
                    # to display the select menu after selection 
                    REPLY=
                done
            else 
                echo "You don't have access to this database"
                echo "---------------------------------------"
                echo
            fi
        fi
        # to display the select menu after selection 
        REPLY=
    done        
else
    echo "You don't have that privilage"
fi
# return to main.sh
echo "---------------------------------------"
echo
PS3="Please, Choose an option: "
return

