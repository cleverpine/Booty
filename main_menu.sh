#!/bin/bash

source ./common.sh
source ./frontend_setup.sh
source ./backend_setup.sh

readonly APP_VERSION=0.0.1
readonly CURRENT_DIR=$(pwd)

display_logo(){
        echo -e "${GREEN}"
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
        echo -e "${NC}"
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
      setup_backend
      # Handle Back-end service setup
      ;;
    3)
      echo "You have selected \"Front-end service\"."
      # setup_git "Front-end"
      setup_frontend
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
      echo "PineBoot version: ${APP_VERSION}"
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