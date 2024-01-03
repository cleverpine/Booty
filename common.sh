
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
        log_verbose "Using project name: $PROJECT_DIR..."
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

    while true; do
        user_prompt "Enter a specific SSH directory (leave blank for default): " SSH_DIR

        # If the input is blank, use the default directory and break the loop
        if [ -z "$SSH_DIR" ]; then
            log_verbose "Using default SSH directory $HOME/.ssh/id_rsa..."
            SSH_DIR="$HOME/.ssh/id_rsa"
            break
        fi

        # Check if the file exists, if so, break the loop
        if [ -f "$SSH_DIR" ]; then
            log_verbose "Using SSH directory: $SSH_DIR..."
            break
        else
            log_error "File $SSH_DIR does not exist. Please enter a valid path to an ssh key."
        fi
    done

    eval "$1=\$SSH_DIR"
}

prompt_cp_libraries() {
    local libraries=()
    local library_keys=()
    local library_values=()
    local library_names=() # New array for names without versions

    if [ "$1" == "FE" ]; then
        libraries=("0:none" "${frontend_libraries[@]}")
    else
        libraries=("0:none" "${backend_libraries[@]}")
    fi

    # Extract keys, values, and names
    for i in "${libraries[@]}"; do
        IFS=':' read -r key name version <<< "$i"
        library_keys+=("$key")
        library_values+=("$name@$version") # Combine name and version with @
        library_names+=("$name") # Add only the name
    done

    log_major_step "Choose additional libraries to install"
    log "Available libraries: "
    for (( i=0; i<${#library_keys[@]}; i++ )); do
        log "   ${library_keys[$i]}. ${library_names[$i]}" # Display name without version
    done
    log ""

    local choices=$2
    local valid_input=0
    while [ $valid_input -eq 0 ]; do
        user_prompt "Enter a comma-separated list of libraries you wish to include, '0' for none (leave blank for all): " choices

        # Check for blank input (select all libraries)
        if [ -z "$choices" ]; then
            choices=$(IFS=,; echo "${library_keys[*]:1}")
            valid_input=1
            continue
        fi

        # Check for 'none' selection
        if [[ "$choices" == "0" ]]; then
            choices=""
            valid_input=1
            continue
        fi

        # Normalize input by removing spaces
        choices=$(echo "$choices" | sed 's/ //g')

        # Validate input
        IFS=',' read -ra selected_libs <<< "$choices"
        local unique_libs=()
        for lib in "${selected_libs[@]}"; do
            if ! [[ $lib =~ ^[0-9]+$ ]] || [[ ! " ${library_keys[*]} " =~ " $lib " ]] || [[ " ${unique_libs[*]} " =~ " $lib " ]]; then
                valid_input=0
                log_error "Invalid input. Please enter valid library numbers separated by commas."
                break
            elif [[ $lib == "0" ]] && [[ ${#selected_libs[@]} -gt 1 ]]; then
                valid_input=0
                log_error "Invalid input. '0' cannot be combined with other selections."
                break
            else
                valid_input=1
                unique_libs+=("$lib")
            fi
        done
    done

    eval "$2=\$choices"
}


prompt_boolean() {
    local prompt_message=$1
    local _varname=$2
    local response

    user_prompt "$prompt_message (y/n)" response
    case $response in
        [Yy] ) eval "$_varname=true";;
        [Nn] ) eval "$_varname=false";;
        * ) 
            # Reprompt user if input is different than 'y' or 'n'
            log_error "Please answer 'y' or 'n'."
            prompt_boolean "$prompt_message" "$_varname"
            ;;
    esac
}


comma_separated_choice_to_array() {
    local IFS=',' 
    read -r -a array <<< "$1"
    echo "${array[@]}"
}


log() {
    echo -e $1 >&2 | tee -a $LOG_FILE

}

log_error() {
    log "${RED}$1${NC}"
}

log_warning() {
    log "${YELLOW}$1${NC}"
}

log_verbose() {
    if [ "$verbose" = 1 ]; then
        log "[DEBUG] $1"
    fi
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