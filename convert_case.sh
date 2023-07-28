string="Increment and Decrement counter"
convert_to_upper=`echo "$string" | awk '{print toupper($0)}'`
#echo $convert_to_upper
sed -i 's/Increment and Decrement counter/INCREMENT AND DECREMENT COUNTER/g' ./web_content/index.html