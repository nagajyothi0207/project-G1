#!/bin/bash
set -e
set -o pipefail
BRANCH=${2}
string="Increment and Decrement counter"
convert_to_upper=`echo "$string" | awk '{print toupper($0)}'`
#echo $convert_to_upper
git pull origin master
sed -i 's/Increment and Decrement counter/INCREMENT AND DECREMENT COUNTER/g' ./web_content/index.html
git checkout -b $BRANCH master
git add .
git commit -am "Website Content is converted to UPPER CASE"
git push -o merge_request.create -o merge_request.target=master  origin $BRANCH
