#first check if user in DB_admins 
PS3="Please, Choose a Database: "
u=$(whoami)
isexist=$(cat DB_admins.db | grep -w $u | wc -l)
if [[ $isexist -eq 1 ]]
then
    # list available DB and select on of them
    select db in $(ls ./Databases) exit
    do
    	# return to main.sh if choosing to exit 
        if [[ $db == exit ]]
        then 
            echo "---------------------------------------"
            echo
            PS3="Please, Choose an option: "
            return
        else
	    # get owner of DB , if user is the owner then create table if not exit
            owner=$(head -1 ./Databases/$db/owner.txt)
            if [[ $owner == $u ]]
            then
                read -p "Enter table name: " tbname
                isexist=$(ls ./Databases/$db/ | grep -w $tbname | wc -l) #check if table already exists 
                if [[ $isexist -eq 1 ]] 
                then
                    echo "This table already exists in this database"
                else
		    #create table and get the number of columns and column names
                    touch ./Databases/$db/$tbname.table
                    read -p "Enter number of columns: " numofco
                    echo "Creating table ($tbname) with $numofco columns ....."
                    index=0
                    header=""
                    while [[ $index -lt $numofco ]]
                    do
                        index=$(($index+1))
                        read -p "Enter column $index name: " cname
			# append column name to header each iteration 
                        if [[ $index -eq $numofco ]]
                        then
                            header=$header$cname
                        else
                            header=$header$cname","
                        fi
                    done
		    #add header to the table
                    echo $header>> ./Databases/$db/$tbname.table
                    echo "Table Created Successfully "
                    echo "---------------------------------------"
		    # return to main.sh
                    echo
                    PS3="Please, Choose an option: "
                    return
                fi
	        else 
		        echo "You're not the owner of this Database and don't have that privilage" 
            fi
        fi
        echo "---------------------------------------"
        echo
	#to display select menu again 
        REPLY=
    done
else
    echo "You're ($(whoami)) not an admin and don't have that privilage"
fi
# return to main.sh
echo "---------------------------------------"
echo
PS3="Please, Choose an option: "
return
