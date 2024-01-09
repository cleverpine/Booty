#!/bin/bash


readonly current_timestamp=$(date +"%Y-%m-%d_%H:%M:%S")
readonly LOG_FILE="PB-Log-${current_timestamp}.log"
readonly ERROR_LOG_FILE="PB-Error-Log-${current_timestamp}.log"
readonly CURRENT_DIR=$(pwd)

display_logo() {

echo -e "${GREEN}"                                                                                      
echo "                                 #####                                          "
echo "                               #########                                        "
echo "                             #############                                      "
echo "                           #################                                    "
echo "                     ####    #############    ####                              "
echo "                     #######    #######    #######                              "
echo "                     ##########         ##########                              "
echo "                     ###########       ###########                              "
echo "                      #######    ####    ########                               "
echo "                      ####    ###########    ####                               "
echo "                ####       #################       ####                         "
echo "                ########   #################   ########                         "
echo "                ###########    #########    ###########                         "
echo "                ##############    ###    ##############                         "
echo -e "                 ###############       ############### ${NC}                 "
echo -e "  ############   ${GREEN}############           #############${NC}  ####     "
echo -e " ###############   ${GREEN} #######                 #######${NC}    #####    "
echo " ####       #####                                      #####                    "
echo " ####       #####     ##########       #########    ###########   ####      ### "
echo " ###############    ##############   ############## ###########  #####     #### "
echo " ###############   #####      ##### #####     ######   #####     #####     #### "
echo " ####       #####  ####       ##########       #####   #####     #####     #### "
echo " ####        ####  #####      ##### #####      #####   #####      ####     #### "
echo " ################   ##############  ###############    #########  ############# "
echo " ###############     ############     ###########       #######    ############ "
echo "                                                                   ##      #### "
echo "                                                                  ############# "
echo "                                                                   ###########  "
                                                                                  
#                                                    
# 
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
    echo "'exit' - Close Booty."
    echo "'version' - Display the current version of Booty."
    echo ""
   
    local choice
    user_prompt "Enter the number of your choice (or type 'help' for more options): " choice
    handle_user_choice
}

# Function to display the main menu
show_main_menu() {
  echo "Welcome to Booty!"
  echo ""
  echo "Please select the type of project you want to set up:"
  echo "1. Entire Project"
  echo "2. Back-end service"
  echo "3. Front-end service"
  echo "4. QA Automation service"
  echo ""

  local choice
  user_prompt "Enter the number of your choice (or type 'help' for more options): " choice

  handle_user_choice
}

# Function to handle user's choice
handle_user_choice() {
  case $choice in
    1)
      log_verbose "You have selected \"Entire Project\"."
      # Handle Entire Project setup
      ;;
    2)
      log_verbose "You have selected \"Back-end service\"."
      setup_backend
      # Handle Back-end service setup
      ;;
    3)
      log_verbose "You have selected \"Front-end service\"."
      setup_frontend
      # Handle Front-end service setup
      ;;
    4)
      log_verbose "You have selected \"QA Automation service\"."
      # Handle QA Automation service setup
      ;;
    help)
      display_help_menu
      ;;
    exit)
      echo "Exiting Booty."
      exit 0
      ;;
    version)
      echo "Booty version: ${APP_VERSION}"
      show_main_menu
      ;;
    *)
      echo "Oops! The number you entered doesn't match any of the available options. Please try again, or type 'help' for more information."
      show_main_menu
      ;;
  esac
}


# Clear the screen
# clear

load_configurations() {
  # Define locations
  readonly FE_LIBRARY_CONFIG_LOCATION="https://raw.githubusercontent.com/cleverpine/Booty/main/booty-configurations/angular-libraries.sh"
  readonly BE_LIBRARY_CONFIG_LOCATION="https://raw.githubusercontent.com/cleverpine/Booty/main/booty-configurations/spring-libraries.sh"
  readonly LOCAL_CONFIG_DIR="./booty-configurations"

  # Load Front-End Library Configurations
  if ! curl -sSfL "${FE_LIBRARY_CONFIG_LOCATION}" -o "angular-libraries.sh"; then
    cp "${LOCAL_CONFIG_DIR}/angular-libraries.sh" .
  fi

  # Load Back-End Library Configurations
  if ! curl -sSfL "${BE_LIBRARY_CONFIG_LOCATION}" -o "spring-libraries.sh"; then
    cp "${LOCAL_CONFIG_DIR}/spring-libraries.sh" .
  fi
}


parse_args() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
        -v|--verbose)
            echo "Verbose mode activated."
            verbose=1
            ;;
        *)
            # Handle other arguments if necessary
            ;;
    esac
    shift
  done
}

# Delete old log files
rm PB-Log-*.log
rm PB-Error-Log-*.log

# Parse command line arguments
parse_args "$@"

# Load library choice configurations
load_configurations

export verbose

# Link all the other files
source ./config.sh
source ./utils/logging.sh
source ./utils/common.sh
source ./utils/git_commands.sh

source ./angular-libraries.sh
source ./spring-libraries.sh
source ./assertions.sh
source ./frontend_setup.sh
source ./backend_setup.sh


# Log all output to a log file, error log to error_log file and everything to terminal
exec > >(tee -a $LOG_FILE) 2> >(tee -a $ERROR_LOG_FILE >&2)

# Display the logo
display_logo

# Show the main menu
show_main_menu