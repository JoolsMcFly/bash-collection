#!/usr/bin/env bash

buildDir=/app/deploy

echo ""
echo "Pruning origin"
git remote prune origin

echo ""
echo "Fetching branches"
git fetch

echo ""
echo "Resetting repo"
git reset --hard HEAD

echo "These branches are available, last updated first."
branchIndex=0
branches=$(git branch -avv --format="%(committerdate:iso8601) - %(refname:short)" | grep origin | grep -v master | grep -v HEAD | sort -r | awk '{print $5}')
echo "0: master                   <----------- default"
declare -a branchesByIndex
branchesByIndex[0]=master
for branch in ${branches}; do
    let branchIndex=${branchIndex}+1
    echo "${branchIndex}: ${branch:7}"
    branchesByIndex[$branchIndex]=${branch:7}
done

checkoutBranch=''
echo "Which branch do you want to checkout? (default=master)"
while [[ -z "$checkoutBranch" ]]
do
    read branch
    branch=$(($branch + 0))
    if [[ -z "$branch" ]]
    then
        checkoutBranch=${branchesByIndex[0]}
    else
        checkoutBranch=${branchesByIndex[branch]}
    fi
    if [[ -z "$checkoutBranch" ]]
    then
        echo "number between 0 and $branchIndex!"
    fi
done

echo ""
echo "Where do you want to deploy to? (1=dev (default), 2=staging, 3=prod)"
read target
destFolder=/app/dev
if [[ ${target} -eq "2" ]]
then
    destFolder=/app/staging
elif [[ ${target} -eq "3" ]]
then
    destFolder=/app/prod
fi

echo ""
echo "About to deploy ${checkoutBranch} to ${destFolder}. Are you OK with that? [y/n]"
read confirmation

if [[ ${confirmation} != "y" && ${confirmation} != "yes" && ${confirmation} != "o" && ${confirmation} != "oui" ]]
then
    git checkout master
    echo "Bailing out!"
    exit 1
fi

echo ""
echo "Let's do this"

echo ""
echo "checking out ${checkoutBranch}"
git checkout ${checkoutBranch}

if [[ $? -eq 1 ]]
then
    echo ""
    git checkout master
    echo "Problem checking out $checkoutBranch"
    exit 1
fi

echo ""
echo "Pulling from origin"
git pull origin ${checkoutBranch}

echo ""
echo "Running composer install"
composer install

echo ""
echo "Installing yarn packages"
yarn

echo ""
echo "Building assets"
yarn run build

cd ${buildDir}
rsync --exclude '.git' --exclude 'node_modules' --exclude '.cache' --exclude '.config' --exclude '.docker' --exclude '.npm' --exclude '.yarn' --exclude 'tests' --exclude 'var' --exclude '.env.local' -av ${buildDir}/ ${destFolder}/
commitId=$(git log --format="%h" -n 1)

cd ${destFolder}
echo ""
echo "Running migrations"
php bin/console doc:mig:mig --no-interaction

date=$(date +"%Y-%m-%d %H:%M:%S")
echo "<p class=\"version-info\">${checkoutBranch}<br />${date}<br />${commitId}</p>" > ./templates/branch-version.html.twig

echo ""
echo "Clearing cache"
rm -rf var/cache/;
php bin/console cache:clear;
chmod 777 var/cache/ -R
chown www-data: var/cache -R
chown www-data: public/uploads/ -R

cd ${buildDir}
git checkout master
echo ""
echo "Push done"
