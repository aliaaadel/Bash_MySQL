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
            #check if user is the owner 
            owner=$(cat ./Databases/$db/owner.txt)
            if [[ $owner == $current ]]
            then
                #list tables and select from them
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
                        #get keyword and delete records corresponding to it 
                        #if keyword is empty then print "empty keyword"
                        read -p "Please enter a delete keyword: " keyword
                        if [ -z "$keyword" ]
                        then
                            echo "Please, Enter a valid search keyword (Not an empty keyword)"
                            echo "---------------------------------------"
                            echo
                        else
                            #delete the records containing keyword and diplay updated table
                            echo
                            echo "Deleting any row containing the word ($keyword) ......" 
                            echo The updated table: 
                            echo
                            sed -i "/\b\($keyword\)\b/d" ./Databases/$db/$tbname
                            cat ./Databases/$db/$tbname
                            echo --------------------------
                        fi
                        
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
