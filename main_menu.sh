#!/bin/bash

readonly SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
readonly current_timestamp=$(date +"%Y-%m-%d_%H:%M:%S")

mkdir -p ${SCRIPT_DIR}/logs
readonly LOG_FILE="logs/PB-Log-${current_timestamp}.log"
readonly ERROR_LOG_FILE="logs/PB-Error-Log-${current_timestamp}.log"
readonly CURRENT_DIR=$(pwd)

source "${SCRIPT_DIR}/config.sh"

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

  if [ -n "$verbose" ] && [ "$verbose" = true ]; then    
    echo "Verbose mode is active"
  fi

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
  readonly QUARKUS_LIBRARY_CONFIG_LOCATION="https://raw.githubusercontent.com/cleverpine/Booty/main/booty-configurations/quarkus-libraries.sh"
  
  readonly LOCAL_CONFIG_DIR="${SCRIPT_DIR}/booty-configurations"

  # Load Front-End Library Configurations
  if ! curl -sSfL "${FE_LIBRARY_CONFIG_LOCATION}" -o "${SCRIPT_DIR}/angular-libraries.sh"; then
    cp "${LOCAL_CONFIG_DIR}/angular-libraries.sh" "${SCRIPT_DIR}/"
  fi

  # Load Back-End Library Configurations
  if ! curl -sSfL "${BE_LIBRARY_CONFIG_LOCATION}" -o "${SCRIPT_DIR}/spring-libraries.sh"; then
    cp "${LOCAL_CONFIG_DIR}/spring-libraries.sh" "${SCRIPT_DIR}/"
  fi

  # Load Quarkus Library Configurations
  if ! curl -sSfL "${QUARKUS_LIBRARY_CONFIG_LOCATION}" -o "${SCRIPT_DIR}/quarkus-libraries.sh"; then
    cp "${LOCAL_CONFIG_DIR}/quarkus-libraries.sh" "${SCRIPT_DIR}/"
  fi
}

delete_old_logs() {
  # Enable nullglob to handle cases where glob patterns do not match any files
  shopt -s nullglob

  # Create arrays of matching log files
  local log_files=(PB-Log-*.log)
  local error_files=(PB-Error-Log-*.log)

  # Delete log files if array is not empty
  if (( ${#log_files[@]} > 0 )); then
    rm "${log_files[@]}" 2>/dev/null
  fi

  # Delete error log files if array is not empty
  if (( ${#error_files[@]} > 0 )); then
    rm "${error_files[@]}" 2>/dev/null
  fi

  # Revert nullglob to its original state
  shopt -u nullglob
}


parse_args() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
        -v|--verbose)
            verbose=true
            ;;
        --version)
              echo "${APP_VERSION}"
              exit 0
            ;;
    esac
    shift
  done
}

# Parse command line arguments
parse_args "$@"

# Delete old log files
delete_old_logs

# Load library choice configurations
load_configurations

export verbose

# Link all the other files
source "${SCRIPT_DIR}/utils/logging.sh"
source "${SCRIPT_DIR}/utils/common.sh"
source "${SCRIPT_DIR}/utils/git_commands.sh"

source "${SCRIPT_DIR}/angular-libraries.sh"
source "${SCRIPT_DIR}/spring-libraries.sh"
source "${SCRIPT_DIR}/quarkus-libraries.sh"

source "${SCRIPT_DIR}/assertions.sh"
source "${SCRIPT_DIR}/frontend_setup.sh"
source "${SCRIPT_DIR}/backend_setup.sh"
source "${SCRIPT_DIR}/qa_setup.sh"


# Log all output to a log file, error log to error_log file and everything to terminal
exec > >(tee -a $LOG_FILE) 2> >(tee -a $ERROR_LOG_FILE >&2)

# Display the logo
display_logo

# Show the main menu
show_main_menu