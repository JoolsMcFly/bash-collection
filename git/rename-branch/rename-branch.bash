#!/bin/bash

currentName=$(git branch | grep \* | awk '{print $2}')
echo "You're on $currentName"
echo "Enter the desired new name:"
read newName

echo "You're about to rename $currentName to $newName"
echo "Do you confirm? (y/n)"
read confirmation

if [ $confirmation != 'y' ]; then
    echo "Renaming cancelled."
    exit
fi

echo "Renaming $currentName to $newName..."
git branch -m $currentName $newName

echo "Deleting old branch"
git push origin :$currentName

echo "Resetting upstream"
git push --set-upstream origin $newName

echo "All good."
