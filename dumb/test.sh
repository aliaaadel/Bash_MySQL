value="fatma"
duplicate_val=$(cat ./Databases/students/students.table | 
awk -F, -v VAL=$value 'BEGIN {
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
        
echo $duplicate_val
if [[ $duplicate_val -gt 0 ]]
then
 echo "Duplicate Primary Key value"
  #  #exit / return to main 
fi

