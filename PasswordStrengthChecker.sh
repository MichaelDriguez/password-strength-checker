#!/bin/bash
echo "-------------------------"
echo "Password Strength Checker"
echo -e "-------------------------\n"

# Score determines how secure the password is.
score=0

# Variables that provide password suggestions at the end of the program.
containsNumbers=false
containsUppercase=false
containsLowercase=false

read -r -p "Please enter a password: " password

if [[ $password =~ [0-9] ]]; then
    (( score ++ ))
    containsNumbers=true
fi

# Checks for uppercase and lowercase letters using regex patterns [A-Z] and [a-z]
if [[ $password =~ [A-Z] ]]; then
    (( score ++ ))
    containsUppercase=true
fi

if [[ $password =~ [a-z] ]]; then
    (( score ++ ))
    containsLowercase=true
fi

clear

echo "Your password: $password"
# Gives value of either weak, moderate, or strong
if [[ $score < 2 ]]; then
    echo "Password strength: Weak"
elif [[ $score -eq 2 ]]; then
    echo "Password strength: Moderate"
elif [[ $score -eq 3 ]]; then
    echo "Password strength: Strong"
fi

# Password suggestions will only display if you are missing certain requirements for a secure password.
if [[ $score < 3 ]]; then
    echo -e "\nPassword Suggestions"
    echo -e "Include the following:\n"
    if ! $containsNumbers; then
        echo "At least 1 number."
    fi

    if ! $containsUppercase; then
        echo "At least 1 uppercase letter."
    fi
    if ! $containsLowercase; then
        echo "At least 1 lowercase letter."
    fi
fi