#first check if user in DB_admins 
current=$(whoami)
isexist=$(cat DB_admins.db | grep -w $current | wc -l)
if [[ $isexist -eq 1 ]]
then
	#list available DB and choose from them
	echo "Available Databases: "
	ls ./Databases/ 
	read -p "Enter The Name Of Database to be deleted: " db_name
	#check if DB exist already if not existent then print DB not found 
	#if it exists then check if the user is the owner 
	output=$(ls ./Databases | grep -w $db_name | wc -l)
	if [[ $output -eq 1 ]]
	then
		if [[ $current == $(cat ./Databases/$db_name/owner.txt) ]] # if user is the owner then delete DB
		then	
			rm -r ./Databases/$db_name 
			echo "Database Deleted Successfully"
		else
			echo "You're not the owner of this Database and don't have that privilage" 
		fi
	else 
		echo Database Not Found
	fi
else
    echo "You're ($(whoami)) not an admin and don't have that privilage"
fi
# return to main.sh
echo "---------------------------------------"
echo
PS3="Please, Choose an option: "
return
