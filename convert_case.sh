#!/bin/bash
set -e
set -o pipefail
BRANCH=${2}
string="Increment and Decrement counter"
convert_to_upper=`echo "$string" | awk '{print toupper($0)}'`
#echo $convert_to_upper
git checkout main
git pull origin main
git checkout -b master main
git add .
git commit -am "Code rebase for pushing to Master Branch"
git push --set-upstream origin master
git checkout -b ${BRANCH} master
git add .
git commit -am "Website Content is converted to UPPER CASE and pushing to Master Branch"
sed -i 's/Increment and Decrement counter/INCREMENT AND DECREMENT COUNTER/g' ./web_content/index.html
git push -o merge_request.create -o merge_request.target=master origin ${BRANCH}
