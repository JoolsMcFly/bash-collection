#!/bin/bash
IFS=$'\n'

declare -a FILES
nbFileFound=0
for file in $(git ls-files -m | grep .php)
do
    results=`docker exec -i DOCKER_CONTAINER_NAME ./php-cs-fixer-v2.phar fix $file --dry-run 2>/dev/null | head -n -2`
    if [ ! -z "$results" ]; then
        FILES[$nbFileFound]="$file"
        nbFileFound=`expr $nbFileFound + 1`
    fi
done

if [ $nbFileFound = 0 ];then
    exit 0
fi

echo ""
echo "php-cs-fixer found issues in the following files:"
printf "%s\n" "${FILES[@]}"
echo ""
echo "Fix them by running the following command in your docker instance :"
echo ""
echo "./php-cs-fixer-v2.phar fix --config=.php_cs ${FILES[@]}"
echo ""
exit 1
