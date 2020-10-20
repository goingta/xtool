#!/bin/bash

curl --silent -u ci_ios:Aa123456 -X POST -H "Accept: application/json"  -H "Content-Type: application/json" "http://mobiledev.camera360.com:7990/rest/api/latest/projects/PGLib/repos/" -d '{"name": "'$1'"}'

if [[ $2 -eq 2 ]]; then
	pod lib create --template-url=ssh://git@mobiledev.camera360.com:7999/pglib/pgt-libtemplate2.git $1
else
	pod lib create --template-url=ssh://git@mobiledev.camera360.com:7999/pglib/pgt-libtemplate.git $1
fi

cd $1
git remote add origin ssh://git@mobiledev.camera360.com:7999/pglib/$1.git
