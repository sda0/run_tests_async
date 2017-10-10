#!/bin/bash

red=`tput setaf 1`
reset=`tput sgr0`
green=`tput setaf 2`

args=""
isSeq=0

while getopts "cus" opt
do
	case "$opt" in
		c) args="--testsuite OnCommit"
		;;
		u) args="--testsuite Unit"
		;;
		s) isSeq=1
	esac
done

test_dirs=$(find "$PWD" -mindepth 2 -maxdepth 3 -name "tests" -not -path "*/vendor/*")

cmd_executor="xargs -P 10 -I {} -t"
if [ ${isSeq} -eq 1 ]; then
	cmd_executor="xargs -I {} -t"
fi;
echo "${test_dirs}" | eval "$cmd_executor bash -c '{}/../vendor/bin/phpunit --configuration {}/phpunit.xml $args'"

status="${PIPESTATUS[1]}"
if [ ${status} -eq 0 ]; then
	echo "${green}TESTS SUCCEEDED${reset}";
	exit 0;
fi;

echo "${red}TESTS FAILED${reset}";
exit 1;
