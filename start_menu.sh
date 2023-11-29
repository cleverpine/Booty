#!/bin/bash

source ./project_setup.sh


# Function to display the ASCII art logo
# display_logo() {
#     echo "                                          ##                                "            
#     echo "                                        ######                              "            
#     echo "                                      ##########                            "            
#     echo "                                    ##############                          "            
#     echo "                            #      ################      #                  "            
#     echo "                            ####      ##########      ####                  "            
#     echo "                             ######      ####      #######                  "            
#     echo "                             #########          #########                   "            
#     echo "                             ##########        ##########                   "            
#     echo "                             #######      ###     #######                   "            
#     echo "                             ####      ########      ####                   "            
#     echo "                       ###          ##############          ###             "            
#     echo "                       ######      ################      ######             "            
#     echo "                       #########      ##########      #########             "            
#     echo "                        ###########      ####      ###########              "            
#     echo "                        ###############         ##############              "            
#     echo "                        ###############        ###############              "            
#     echo "                  #       ##########      ##       #########       #        "            
#     echo "                  ####       ###      ##########      ###       ####        "            
#     echo "                  #######          ################          #######        "            
#     echo "                   #######         ################         #######         "            
#     echo "                   ####      ###      ##########      ###      ####         "            
#     echo "                   #      #########      ####      #########      #         "            
#     echo "                       ###############          ###############             "            
#     echo "                       ################        ################             "            
#     echo "                          ##########      ###     ##########                "            
#     echo "                             ####      ########      ####                   "            
#     echo "                                    ##############                          "            
#     echo "                                   ################                         "            
#     echo "                                      ##########                            "            
#     echo "                                         ####                               "
#     echo "                                                                            "

#     echo "                                                                            "
#     echo "                                                                            "
#     echo "                      _____ _            ____               _               "
#     echo "                      |  __ (_)          |  _ \            | |              "
#     echo "                      | |__) | _ __   ___| |_) | ___   ___ | |_             "
#     echo "                      |  ___/ | '_ \ / _ \  _ < / _ \ / _ \| __|            "
#     echo "                      | |   | | | | |  __/ |_) | (_) | (_) | |_             "
#     echo "                      |_|   |_|_| |_|\___|____/ \___/ \___/ \__|            "
#     echo "                                                                            "
#     echo "                                                                            "
# }

# display_logo() {
#     echo "                                                      "            
#     echo "                                                      "            
#     echo "                    ##                                "            
#     echo "                ##########                            "            
#     echo "              ##############                          "            
#     echo "      #      ################      #                  "            
#     echo "      ####      ##########      ####                  "            
#     echo "       ######      ####      #######                  "            
#     echo "       #########          #########                   "            
#     echo "       ##########        ##########                   "            
#     echo "       #######      ###     #######              _____ _            ____               _     "            
#     echo "       ####      ########      ####              |  __ (_)          |  _ \            | |    "            
#     echo " ###          ##############          ###        | |__) | _ __   ___| |_) | ___   ___ | |_   "            
#     echo " ######      ################      ######        |  ___/ | '_ \ / _ \  _ < / _ \ / _ \| __|  "            
#     echo " #########      ##########      #########        | |   | | | | |  __/ |_) | (_) | (_) | |_   "            
#     echo "  ###########      ####      ###########         |_|   |_|_| |_|\___|____/ \___/ \___/ \__|  "
#     echo "                                                      "            
#     echo "                                                      " 
# }

display_logo(){
        echo "                                                            "            
        echo "                                                            "            
        echo "                                                            "            
        echo "                          ##                                "    
        echo "                        ######                              "            
        echo "                      ##########                            "            
        echo "                    ##############                          "            
        echo "             #     ################      #                  "            
        echo "             ####     ##########      ####                  "            
        echo "             ######      ####      #######                  "            
        echo "             #########           #########                  "            
        echo "             ##########         ##########                  "            
        echo "             #######      ###      #######                  "
        echo "       #     ####      ########       ####    #             "
        echo "       ###          ##############          ###             "
        echo "       ######      ################      ######             "
        echo "       #########      ##########      #########             "
        echo "        ###########      ####      ###########              "
        echo "                                                             "
        echo "   _____  _               ____                 _             "
        echo "  |  __ \(_)             |  _ \               | |            "
        echo "  | |__) |_  _ __    ___ | |_) |  ___    ___  | |_           "
        echo "  |  ___/| || '_ \  / _ \|  _ <  / _ \  / _ \ | __|          "
        echo "  | |    | || | | ||  __/| |_) || (_) || (_) || |_           "
        echo "  |_|    |_||_| |_| \___||____/  \___/  \___/  \__|          "
        echo "                                                             "            
        echo "                                                             "  
#                                                    
# 
}




# Function to display the main menu
show_main_menu() {
  echo "Welcome to PineBoot!"
  echo ""
  echo "Please select the type of project you want to set up:"
  echo "1. Entire Project"
  echo "2. Back-end service"
  echo "3. Front-end service"
  echo "4. QA Automation service"
  echo ""
  read -p "Enter the number of your choice (or type 'help' for more options): " choice
}

# Function to execute git commands
execute_git_commands() {
  # Your git commands here
  echo "Executing git commands..."
}

# Function to set environment variables
set_environment_variables() {
  # Your commands to set environment variables here
  echo "Setting environment variables..."
}

# Function to call Java application
call_java_application() {
  # Your command to run Java application here
  echo "Calling Java application..."
}

# Function to call Node application
call_node_application() {
  # Your command to run Node application here
  echo "Calling Node application..."
}

# Function to display help menu
display_help_menu() {
    echo "Help Options:"
    echo "1. Entire Project - Sets up a new project including one or multiple front-end, back-end, and QA automation services."
    echo "2. Back-end service - Initializes a back-end service template with all necessary configurations."
    echo "3. Front-end service - Generates a front-end service template ready for development."
    echo "4. QA Automation service - Creates a QA automation service setup with testing frameworks."
    echo ""
    echo "Additional Commands:"
    echo "'exit' - Close PineBoot."
    echo "'version' - Display the current version of PineBoot."
    echo ""
    read -p "Enter the number of your choice or a command: " choice
    handle_user_choice
}

# Function to display the main menu
show_main_menu() {
  echo "Welcome to PineBoot!"
  echo ""
  echo "Please select the type of project you want to set up:"
  echo "1. Entire Project"
  echo "2. Back-end service"
  echo "3. Front-end service"
  echo "4. QA Automation service"
  echo ""
  read -p "Enter the number of your choice (or type 'help' for more options): " choice
  handle_user_choice
}

# Function to handle user's choice
handle_user_choice() {
  case $choice in
    1)
      echo "You have selected \"Entire Project\"."
      # Handle Entire Project setup
      ;;
    2)
      echo "You have selected \"Back-end service\"."
      handle_project_setup "Back-end"
      # Handle Back-end service setup
      ;;
    3)
      echo "You have selected \"Front-end service\"."
      handle_project_setup "Front-end"
      # Handle Front-end service setup
      ;;
    4)
      echo "You have selected \"QA Automation service\"."
      # Handle QA Automation service setup
      ;;
    help)
      display_help_menu
      ;;
    exit)
      echo "Exiting PineBoot."
      exit 0
      ;;
    version)
      echo "PineBoot version: 0.0.1"
      # Or fetch the version dynamically if needed
      ;;
    *)
      echo "Oops! The number you entered doesn't match any of the available options. Please try again, or type 'help' for more information."
      show_main_menu
      ;;
  esac
}

# Other functions here (e.g., execute_git_commands, set_environment_variables, etc.)

# Clear the screen
clear

# Display the logo
display_logo

# Show the main menu
show_main_menu