#!/bin/bash

# Prompt for user's name
read -p "Enter your name: " userName

# Define the main directory name
main_dir="submission_reminder_${userName}"

# Create main directory
mkdir -p "$main_dir"

# Create subdirectories
mkdir -p "$main_dir/app"
mkdir -p "$main_dir/config"
mkdir -p "$main_dir/modules"
mkdir -p "$main_dir/assets"

# Create necessary files
touch "$main_dir/config/config.env"
touch "$main_dir/app/reminder.sh"
touch "$main_dir/modules/functions.sh"
touch "$main_dir/assets/submission.txt"
touch "$main_dir/startup.sh"

# Populate the files
cat <<EOF > $main_dir/app/reminder.sh
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: \$ASSIGNMENT"
echo "Days remaining to submit: \$DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions \$submissions_file
EOF

cat <<EOF > $main_dir/modules/functions.sh
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=\$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=\$(echo "\$student" | xargs)
        assignment=\$(echo "\$assignment" | xargs)
        status=\$(echo "\$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "\$assignment" == "\$ASSIGNMENT" && "\$status" == "not submitted" ]]; then
            echo "Reminder: \$student has not submitted the \$ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "\$submissions_file") # Skip the header
}
EOF

cat <<EOF > $main_dir/assets/submissions.txt
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Kelvin, Git, not submitted
Alvin, Shell basics, submitted
Levy, Git, not submitted
Dina, Shell Navigation, submitted
Herve, Git, not submitted
EOF

cat <<EOF > $main_dir/config/config.env
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

cat <<EOF > $main_dir/startup.sh
#!/bin/bash

# Load environment variables and functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Check if the submissions file exists
if [ ! -f "\$submissions_file" ]; then
	    echo "Error: Submissions file not found at \$submissions_file"
	        exit 1
fi

# Display assignment details from the environment variables
echo "Assignment: \$ASSIGNMENT"
echo "Days remaining to submit: \$DAYS_REMAINING days"
echo "----------------------------------------------"

# Call the function to check submissions
check_submissions "\$submissions_file"

# Final message
echo "Reminder app started successfully!"
EOF

# Make the files executable
chmod +x $main_dir/app/reminder.sh
chmod +x $main_dir/modules/functions.sh
chmod +x $main_dir/startup.sh
