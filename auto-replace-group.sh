#!/bin/bash

read -p "Enter group number (ex. group-1): " group_number

group_pattern="<group-no>"

working_directory="../"

find "$working_directory" -type f \( -name "*.yaml" -o -name "*.yml" \) -exec sed -i "" "s/$group_pattern/$group_number/g" {} \;
