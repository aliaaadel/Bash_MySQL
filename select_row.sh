#first check if user in DB_admins 
PS3="Please, Choose a Database: "
current=$(whoami)
isexist=$(cat DB_admins.db | grep -w $current | wc -l)
if [[ $isexist -eq 1 ]]
then
    # list available DB and select on of them
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
                    PS3="Please, Choose an option: "
                    select opt in select_all search exit #user selects whether to search a keyword or display table 
                    do
                        #if user chose to exit return to main.sh 
                        if [[ $opt == exit ]]
                        then 
                            echo "---------------------------------------"
                            echo
                            PS3="Please, Choose an option: "
                            return
                        elif [[ $opt == select_all ]]
                        then
                            #display all data inside selected table
                            echo
                            cat ./Databases/$db/$tbname
                        else
                            #get keyword and display records corresponding to it 
                            #if keyword is empty then print "empty keyword"
                            read -p "Please enter a search keyword: " keyword
                            if [[ -z "$keyword" ]]
                            then
                                echo "Please, Enter a valid search keyword (Not an empty keyword)"
                            else
                                #search for keyword in table if not found print "no rows selescted"
                                output=$(grep -w -i $keyword ./Databases/$db/$tbname | wc -l)
                                echo
                                if [[ output -gt 0 ]]
                                then
                                    grep -w -i $keyword ./Databases/$db/$tbname
                                else
                                    echo No rows selected
                                fi
                            fi
                        fi
                        echo "---------------------------------------"
                        echo
                        REPLY=
                    done
                fi
            done
        fi
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
