#start to check if the user is an Admin or not 
current=$(whoami)
isexist=$(cat DB_admins.db | grep -w $current | wc -l)
if [[ $isexist -eq 1 ]]
then
	#get DB name from user
	read -p "Enter DB name: " db_name
	output=$(ls ./Databases | grep -w $db_name | wc -l)
	if [[ $output -eq 1 ]] #check if the DB already exists 
	then
		echo This database already exists
	else 
		#create dir and parent dir if not existent 
		mkdir -p ./Databases/$db_name 
		echo "Database Created Successfully "
		echo $current >> ./Databases/$db_name/owner.txt # create owner.txt and add user to it 
	fi
else
    echo "You're ($(whoami)) not an admin and don't have that privilage"
fi
echo "---------------------------------------"
echo
# return to main.sh 
PS3="Please, Choose an option: " 
return 
