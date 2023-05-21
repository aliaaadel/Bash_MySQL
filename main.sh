PS3="Please, Choose an option: "
#select from list of options inside txt file
select option in $(cat ./options.txt) exit
do
if [[ $option == exit ]]
then 
	return 
else
	. $option
fi
#display select menu after selection 
REPLY=
done
