#!/bin/bash

echo "-------------------------"
echo "Password Strength Checker"
echo -e "-------------------------\n"

FILE="default-passwords.txt"
FILE_PATH="$(dirname "$0")/$FILE"

# This portion checks if the entered password matches with a default password.
if ! [ -f "$FILE_PATH" ]; then
    echo "Error: '$FILE' was not found."
    echo "Shutting down program..."
    exit 1
fi

# Score determines how secure the password is.
score=0

# Variables that provide password suggestions at the end of the program.
isDefaultPassword=false
containsNumbers=false
containsSymbols=false
containsUppercase=false
containsLowercase=false

read -r -p "Please enter a password: " input

# If the input has a space, everything from the space onwards
# is omitted from the password strength checker.
password=$(echo "$input" | cut -d' ' -f1)

# Variable for password length
length=${#password}

# Checks for numbers using regex patterns [0-9]
if [[ $password =~ [0-9] ]]; then
    (( score ++ ))
    containsNumbers=true
fi

# Checks for symbols using regex patterns [^a-zA-Z0-9]
if [[ $password =~ [^a-zA-Z0-9] ]]; then
    (( score ++ ))
    containsSymbols=true
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

# Checks if the password length is greater than or equal to twelve characters.
# Bonus points are given to longer passwords.
# Points are also taken away for shorter passwords.
if [[ $length -ge 20 ]]; then
    (( score +=2 ))
elif [[ $length -ge 12 ]]; then
    (( score ++ ))
elif [[ $length -lt 12 ]]; then
    (( score -- ))
fi

# Checks if the user-submitted password matches any of the default passwords.
while IFS= read -r line; do
  if [ "$line" = "$password" ]; then
    (( score = 0 ))
    isDefaultPassword=true
    break
  fi
done <"$FILE_PATH"

clear

echo "Your password: $password"

if [[ $length -eq 1 ]]; then
    echo "Password length: $length character long"
else
    echo "Password length: $length characters long"
fi

# Gives value of either weak, moderate, strong, or very strong.
if [[ $score -lt 3 ]]; then                     
    echo "Password strength: Weak"              # Weak - A score of 2 or less
elif [[ $score -le 4 ]]; then                   
    echo "Password strength: Moderate"          # Moderate - A score of 3 or 4
elif [[ $score -eq 5 ]]; then                   
    echo "Password strength: Strong"            # Strong - A score of 5  
elif [[ $score -ge 6 ]]; then                   
    echo "Password strength: Very Strong"       # Very Strong - A score of 6 or greater
fi

# Password suggestions will only display if you are missing certain requirements for a secure password.
if [[ $score -lt 0 ]]; then
    echo -e "\nPassword Suggestions"
    echo -e "Include the following:\n"
    echo "A password."
elif [[ $score -lt 5 ]]; then
    echo -e "\nPassword Suggestions"

    if $isDefaultPassword; then
        echo -e "Do not use a default password."
        exit 1
    fi

    echo -e "Include the following:\n"

    if ! $containsNumbers; then
        echo "At least 1 number."
    fi
    if ! $containsSymbols; then
    echo "At least 1 symbol."
    fi
    if ! $containsUppercase; then
        echo "At least 1 uppercase letter."
    fi
    if ! $containsLowercase; then
        echo "At least 1 lowercase letter."
    fi
    if [[ $length -lt 12 ]]; then
        echo "A password that contains at least 12 characters."
    fi
fi

echo ""