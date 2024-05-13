#!/bin/bash

read -p "Enter group number (ex. group-1-b2): " group_number

group_pattern="<GROUP_NO>"

working_directory="./"

find "$working_directory" -type f \( -name "*.yaml" -o -name "*.yml" \) -exec sed -i "" "s/$group_pattern/$group_number/g" {} \;

echo "✅ DONE: $group_number is replaced in all yaml files."
