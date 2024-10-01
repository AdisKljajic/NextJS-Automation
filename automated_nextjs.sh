# NEXT-JS-AUTOMATION
# Author: Adis Kljajic
# Date Written: 09/30/2024
# NEXTJS Initial Setup Automated Process

# How To Run File ./automated_nextjs.sh ApplicationName
# If you get permission denied run the following command:
# chmod +x automate_nextjs.sh

# Initial Project Setup

#!/usr/bin/env expect

# Set the timeout to -1 so it will wait indefinitely for a response
set timeout -1

# Define the project name variable
set project_name "nextjs-automation"
set create_project_folders "yes"
set add_server_based_dependencies "yes"
set create_prefilled_env_variables_file "no"

# Function to ask the user if they want to continue or exit
# To use the prompt below run the following
# continue_or_exit "Do you want to create the project folder? (yes/no)"
proc continue_or_exit {prompt} {
    puts $prompt
    expect_user -re "(yes|no)\n"
    if {[string tolower $expect_out(1,string)] == "no"} {
        puts "Exiting script."
        exit 0
    }
}

# Spawn the create-next-app process
# With a lowercase project name
spawn npx create-next-app@latest ./$project_name

# Short delay after spawn to ensure the process has time to load
sleep 1

# Answer the TypeScript question
expect {
    "*TypeScript*" {
        send "No\r"
    }
}

# Answer the ESLint question
expect {
    "*ESLint*" {
        send "No\r"
    }
}

# Answer the Tailwind CSS question
expect {
    "*Tailwind*" {
        send "Yes\r"
    }
}

# Modify this to catch src directory prompt with a regex
expect {
    -re ".*src.*directory.*" {
        send "No\r"
    }
}

# Answer the App Router question
expect {
    "*App Router*" {
        send "Yes\r"
    }
}

# Modify the matching pattern for the import alias question
expect {
    -re ".*customize.*import.*alias.*" {
        send "No\r"
    }
}

# Wait for the process to finish
expect eof

# Output a completion message
puts "Project initial setup is complete adding project dependencies...."

# Add Additional Dependencies Using NPM
# 1. bcrypt - Use to hash passwords
# 2. mongodb - Use as the database
# 3. mongoose - Help manage database
# 4. next-auth - Authentication session management
# npm install bcrypt mongodb mongoose next-auth
if {$add_server_based_dependencies == "yes" } {
    # Add Additional Dependencies Using NPM
    # Cd Into New Project File
    cd $project_name
    # Add Additional Dependencies Using NPM
    puts "Adding additional dependencies: bcrypt, mongodb, mongoose, next-auth..."
    exec npm install bcrypt mongodb mongoose next-auth > npm_install.log 2>&1

    # Check for any warnings or errors
    set log_content [read [open "npm_install.log"]]
    if {[string length $log_content] > 0} {
        puts "NPM Install Log:"
        puts $log_content
    }

    # Clean up the log file
    exec rm -f npm_install.log
} else {
    puts "Project Dependenices have been skipped. Continuing to next process..."
}

# Output propt will continue the script
puts "Script has been conitnued, creating project folders."

if {$create_project_folders == "yes"} {
    # Following the script below
    # 1. app - Recreate new folder
    # 2. components - Create new folder for components
    # 3. models - This is for mongoDB models
    # 4. public - Recreate new folder
    # 5. styles - Create new styles folder
    # 6. utils - Create new utils folder
    # 7. .env - Create an enviorment variable file
    # Ask the user if they want to create project folders
    
    # Remove the nextjs-automation folder
    exec rm -rf ./app

    # Create a new folder named 'app'
    exec mkdir ./app

    puts "New folder 'app' has been created."

    # Create a new folder named 'components'
    exec mkdir ./components
    puts "New folder 'components' has been created."

    # Create a new folder named 'models'
    exec mkdir ./models
    puts "New folder 'models' has been created."

    # Remove the nextjs-automation folder
    exec rm -rf ./public
    # Create a new folder named 'public'
    exec mkdir ./public
    puts "New folder 'public' has been created."

    # Create a new folder named 'styles'
    exec mkdir ./styles
    puts "New folder 'styles' has been created."

    # Create a new folder named 'utils'
    exec mkdir ./utils
    puts "New folder 'utils' has been created."

    if {$create_prefilled_env_variables_file == "yes" } {
        # Create a .env file with example variables
        set env_file [open "./.env" "w"]
        puts $env_file "MONGODB_URI=mongodb://localhost:27017/mydatabase"
        puts $env_file "NEXTAUTH_URL=http://localhost:3000"
        puts $env_file "NEXTAUTH_SECRET=your_secret_here"
        close $env_file
        puts ".env file has been created with example variables."
    } else {
        # Create an empty .env file
        set env_file [open "./.env" "w"]
        close $env_file
    }
    # Project Folder Structure Complete
    puts "Project Folders Have Been Created And Complete."
}  else {
    puts "Project folder creation has been skipped. Exiting script."
    exit 0
}

puts "Project complete you can now run the project."

# Exit and complete the script
exit 0
