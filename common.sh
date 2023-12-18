source ./git_commands.sh

export RED='\033[31m'
export GREEN='\033[32m'
export PURPLE='\033[35m'
export YELLOW='\033[33m'
export BOLD='\033[1m'
export NC='\033[0m' # No Color

# Backend libraries
backend_libraries=(
    "1:cp-spring-jpa-specification-resolver"
    "2:cp-spring-error-util"
    "3:cp-virava-spring-helper"
    "4:cp-jpa-specification-resolver"
    "5:cp-logging-library"
)

# Frontend libraries
frontend_libraries=(
    "1:cp-lht-header"
    "2:cp-lht-sidebar"
    "3:cp-lht-tile"
    "4:primeng"
    "5:syncfusion"
    "6:ng-openapi-gen"
)


prompt_project_name() {
    log ""
    user_prompt "Enter name for your $service_type project: " PROJECT_DIR

    if [ -z "$PROJECT_DIR" ]; then
        log_error "You must select a project name."
        prompt_project_name
    #elif directory already exists remprompt user
    elif [ -d "$PROJECT_DIR" ]; then
        log_error "Directory $PROJECT_DIR already exists. Please choose a different name."
        prompt_project_name $1
    else
        log "Using project name: $PROJECT_DIR..."
    fi

    eval "$1=\$PROJECT_DIR"
}

prompt_git_remote() {
    log ""

    user_prompt "Paste a clone URL (leave blank if none): " GIT_REMOTE_URL
    eval "$1=\$GIT_REMOTE_URL"
}


configure_ssh() {
    log ""

    user_prompt "Enter a specific SSH directory (leave blank for default): " SSH_DIR
    if [ -z "$SSH_DIR" ]; then
        log "Using default SSH directory."
        SSH_DIR="$HOME/.ssh/id_rsa"
    fi

    #if file with path $SSH_DIR does not exist, reprompt user
    if [ ! -f "$SSH_DIR" ]; then
        log_error "File $SSH_DIR does not exist. Please enter a valid path to an ssh key."
        configure_ssh
    else
        log "Using SSH directory: $SSH_DIR..."
    fi

    eval "$1=\$SSH_DIR"
}

prompt_cp_libraries() {
    local libraries=()
    local library_keys=()
    local library_values=()

    if [ "$1" == "FE" ]; then
        libraries=("${frontend_libraries[@]}")
    else
        libraries=("${backend_libraries[@]}")
    fi

    # Extract keys and values
    for i in "${libraries[@]}"; do
        IFS=':' read -r key value <<< "$i"
        library_keys+=("$key")
        library_values+=("$value")
    done

    log_major_step "Choose additional libraries to install"
    log "Available libraries: "
    for (( i=0; i<${#library_keys[@]}; i++ )); do
        log "   ${library_keys[$i]}. ${library_values[$i]}"
    done
    log ""

    local choices=$2
    local valid_input=0
    while [ $valid_input -eq 0 ]; do
        user_prompt "Enter a comma-separated list of all libraries you wish to include (leave blank for none): " choices
        valid_input=1
        # ... rest of the function remains the same
    done

    eval "$2=\$choices"
}

# prompt_cp_libraries() {
#     # If $1 is "FE", then display frontend libraries, else display backend libraries
#     local available_libraries
#     if [ "$1" == "FE" ]; then
#         available_libraries=("${!frontend_libraries[@]}")
#     else
#         available_libraries=("${!backend_libraries[@]}")
#     fi

#     log_major_step "Choose additional libraries to install"
#     log "Available libraries: "
#     for key in "${available_libraries[@]}"; do
#         if [ "$1" == "FE" ]; then
#             log "   $key. ${frontend_libraries[$key]}"
#         else
#             log "   $key. ${backend_libraries[$key]}"
#         fi
#     done
#     log ""

#     local choices valid_input
#     valid_input=0
#     while [ $valid_input -eq 0 ]; do
#         read -p "Enter a comma-separated list of all libraries you wish to include (leave blank for none): " choices
#         if [[ -z "$choices" ]]; then
#             log "No libraries selected."
#             valid_input=1
#             continue
#         fi

#         # Check if choices are in the correct format and valid
#         if [[ $choices =~ ^[0-9]+(,[0-9]+)*$ ]]; then
#             IFS=',' read -r -a choices_array <<< "$choices"
#             valid_input=1
#             for choice in "${choices_array[@]}"; do
#                 if ! [[ " ${available_libraries[*]} " =~ " $choice " ]]; then
#                     log "Invalid choice: $choice. Please try again."
#                     valid_input=0
#                     break
#                 fi
#             done
#         else
#             log "Invalid format. Please enter a comma-separated list of numbers."
#         fi
#     done

#     log "$choices"
#     echo "$choices"
# }


comma_separated_choice_to_array() {
    local IFS=',' 
    read -r -a array <<< "$1"
    echo "${array[@]}"
}


log() {
    >&2 echo -e $1

}

log_error() {
    log "${RED}$1${NC}"
}


log_major_step() {
    log ""
    log "----------------------------------------------------------------------------------------------------------------------------"
    log "${PURPLE}$1${NC}"
    log "----------------------------------------------------------------------------------------------------------------------------"
    log ""
}

library_numbers_to_names() {
    local library_numbers=$1
    local service_type=$2
    local library_names=""
    local IFS=','
    local libraries=()

    if [ "$service_type" == "FE" ]; then
        libraries=("${frontend_libraries[@]}")
    elif [ "$service_type" == "BE" ]; then
        libraries=("${backend_libraries[@]}")
    else 
        log_error "Invalid service type: $service_type"
        exit 1
    fi

    for number in $library_numbers; do
        for lib in "${libraries[@]}"; do
            IFS=':' read -r key value <<< "$lib"
            if [ "$key" == "$number" ]; then
                library_names+="$value, "
                break
            fi
        done
    done

    # Remove the trailing comma and echo the result
    echo "${library_names%, }"
}

user_prompt() {
    local prompt_message=$1
    local _varname=$2

    # Set the color to green for the prompt message
    printf "${BOLD}${GREEN}${prompt_message} ${YELLOW}"

    local _input
    read _input

    # Reset the text color
    printf "${NC}"

    # Assign the input to the variable whose name was passed
    eval "$_varname=\$_input"
}