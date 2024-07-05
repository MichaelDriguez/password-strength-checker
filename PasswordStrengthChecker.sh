#!/bin/bash

echo "-------------------------"
echo "Password Strength Checker"
echo -e "-------------------------\n"

# Score determines how secure the password is.
score=0

# Variables that provide password suggestions at the end of the program.
containsNumbers=false

read -r -p "Please enter a password: " password

if [[ $password =~ [0-9] ]]; then
    (( score ++ ))
    containsNumbers=true
fi

clear

echo "Your password: $password"

# Gives value of either weak, moderate, or strong
if [[ $score -eq 0 ]]; then
    echo "Password strength: Weak"
elif [[ $score -eq 1 ]]; then
    echo "Password strength: Moderate"
fi

# Password suggestions will only display if you are missing certain requirements for a secure password.
if [[ $score < 1 ]]; then
    echo -e "\nPassword Suggestions"
    echo -e "Include the following:\n"

    if ! $containsNumbers; then
        echo "At least 1 number."
    fi
fi