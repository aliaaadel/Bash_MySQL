#first check if user in DB_admins 
current=$(whoami)
isexist=$(cat DB_admins.db | grep -w $current | wc -l)
if [[ $isexist -eq 1 ]]
then
	#list all Admins
	echo "Signed Admins: "
	cat DB_admins.db 
	echo ----------------------------
	# check user entered if not oracle then it will be deleted 
	read -p "enter Admin name to be deleted: " delname
	if [[ $delname == 'oracle' ]]
	then
		echo "Oracle Admin can't be deleted"
	else
		#check id user exists
		isexist=$(cat DB_admins.db | grep -w $delname | wc -l)
		if [[ $isexist -eq 1 ]]
		then
			# echo $(sed -i /$delname/d DB_admins.db)
			sed -i "/\b\($delname\)\b/d" DB_admins.db
			echo $delname was deleted successfully.
		else
			echo This user is not an admin already!
		fi
	fi
	
else
    echo "You're ($(whoami)) not an admin and don't have that privilage"
fi
# return to main.sh
echo "---------------------------------------"
echo
PS3="Please, Choose an option: "
return
