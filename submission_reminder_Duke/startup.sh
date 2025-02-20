#!/bin/bash

# Load environment variables and functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Check if the submissions file exists
if [ ! -f "$submissions_file" ]; then
	    echo "Error: Submissions file not found at $submissions_file"
	        exit 1
fi

# Display assignment details from the environment variables
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "----------------------------------------------"

# Call the function to check submissions
check_submissions "$submissions_file"

# Final message
echo "Reminder app started successfully!"
