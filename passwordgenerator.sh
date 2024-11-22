#!/bin/bash

# Prompt for password length
read -p "Enter password length (6-100): " length

# Validate password length
if [[ "$length" -lt 6 || "$length" -gt 100 ]]; then
  echo "Error: password length must be between 6 and 100 characters."
  exit 1
fi

# Define character set
charset="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789:;'\"<,>.?/!@#$%^&*()_-+="

# Generate random password
password=$(echo "$charset" | fold -w1 | shuf | head -n"$length" | tr -d '\n') 

# Display the password
echo "Your password is: $password" | tee password.txt
