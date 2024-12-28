#!/bin/bash

# Prompt for password length
read -p "Enter password length (6-100): " length

# Validate password length
if [[ "$length" -lt 6 || "$length" -gt 100 ]]; then
  echo "Error: password length must be between 6 and 100 characters."
  exit 1
fi

# Define character sets for different categories
lowercase="abcdefghijklmnopqrstuvwxyz"
uppercase="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
digits="0123456789"
# Removed special symbols that could cause issues with the shell
symbols="!#$%&+-()/?:;*~={\[]}"

# Initialize an empty string to track used characters
used_chars=""

# Function to add a random character from a given set, ensuring no repetition
get_random_char() {
  local charset="$1"
  local char=""
  
  while true; do
    # Select a random character from the charset
    char=$(echo "$charset" | fold -w1 | shuf | head -n1)
    
    # If the character has not been used, break the loop
    if [[ ! "$used_chars" =~ $char ]]; then
      used_chars+="$char"  # Add the character to the used set
      break
    fi
  done
  
  echo "$char"
}

# Ensure the password contains at least one character from each set
password="$(
  # Pick one character from each category, ensuring no repetition
  echo -n "$(get_random_char "$lowercase")"
  echo -n "$(get_random_char "$uppercase")"
  echo -n "$(get_random_char "$digits")"
  echo -n "$(get_random_char "$symbols")"
)"

# Generate the remaining characters from the full character set, ensuring no repetition
remaining_length=$((length - 4))  # Subtract 4 since we've already added one of each type

# Define the full character set for random characters
charset="$lowercase$uppercase$digits$symbols"

# Add random characters to meet the desired length, ensuring no repetition
for ((i = 0; i < remaining_length; i++)); do
  password+=$(get_random_char "$charset")
done

# Shuffle the password to ensure randomness in character order
password=$(echo "$password" | fold -w1 | shuf | tr -d '\n')

# Display the password
echo "Your password is: $password" | tee password.txt
