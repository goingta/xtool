#!/bin/sh

if [ ! -d simian_reports ];then
	mkdir simian_reports
fi
touch -c simian.old.xml
touch -c simian.new.xml

cd ../..

# TODO change the path
java -jar Camera360/Scripts/simian.jar  -includes="Camera360/Classes/**/*.m" -includes="Camera360/Classes/**/*.mm" -threshold=21 -formatter=xml > Camera360/Scripts/simian_reports/simian.old.xml
tail +4 Camera360/Scripts/simian_reports/simian.old.xml > Camera360/Scripts/simian_reports/simian.new.xml
#sed -i '' -e '$ d' Camera360/Scripts/simian_reports/simian.new.xml
