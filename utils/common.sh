PARSE_VERSION_REGEX='[0-9]+(\.[0-9]+)*'
SPECIAL_CHARACTERS_REGEX='^[a-zA-Z0-9_-]+$'


is_valid_input() {
    local input=$1

    if [[ $input =~ $SPECIAL_CHARACTERS_REGEX ]]; then
        return 0
    else
        return 1
    fi

}

strip_version() {
    local version=$1
    echo $version | grep -oE $PARSE_VERSION_REGEX | head -n 1
}

prompt_project_name() {
    while true; do
        user_prompt "Provide name for your project: " PROJECT_DIR

        
# Validation needed here!
        if ! is_valid_input "$PROJECT_DIR"; then
            log_error "Invalid project name. Please use only letters, numbers, hyphens, and underscores."
        elif [ -z "$PROJECT_DIR" ]; then
            log_error "You must select a project name."
        elif [ -d "$PROJECT_DIR" ]; then
            log_error "Directory $PROJECT_DIR already exists. Please choose a different name."
        else
            log_verbose "Using project name: $PROJECT_DIR..."
            break
        fi
    done

    eval "$1=\$PROJECT_DIR"
}

prompt_git_remote() {
    log ""

    user_prompt "Provide Git remote repository URL as origin (blank for none): " GIT_REMOTE_URL
    eval "$1=\$GIT_REMOTE_URL"
}


configure_ssh() {
    log ""

    while true; do
        user_prompt "Provide SSH private key path (absolute, blank for default):" SSH_DIR

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
    local library_names=()
    local library_descs=() # Array for library descriptions

    if [ "$1" == "ANGULAR" ]; then
        libraries=("0:none" "${angular_libraries[@]}")
        library_descs=("No additional libraries will be installed" "${angular_libs_descriptions[@]}")
    elif [ "$1" == "REACT" ]; then
        libraries=("0:none" "${react_libraries[@]}")
        library_descs=("No additional libraries will be installed" "${react_libs_descriptions[@]}")
    elif [ "$1" == "SPRING" ]; then
        libraries=("0:none" "${spring_libraries[@]}")
        library_descs=("No additional libraries will be installed" "${spring_libs_descriptions[@]}")
    elif [ "$1" == "QUARKUS" ]; then
        libraries=("0:none" "${quarkus_libraries[@]}")
        library_descs=("No additional libraries will be installed" "${quarkus_libs_descriptions[@]}")
    else 
        log_error "Invalid service type: $1"
        exit 1
    fi

    # Extract keys, values, and names
    for i in "${libraries[@]}"; do
        IFS=':' read -r key name version <<< "$i"
        library_keys+=("$key")
        library_values+=("$name@$version")
        library_names+=("$name")
    done

    local choices=$2
    local valid_input=0
    while [ $valid_input -eq 0 ]; do
        log_major_step "Choose additional libraries to install"

        if [[ "$choices" == "help" ]]; then
            # Display library names with descriptions
            for (( i=0; i<${#library_keys[@]}; i++ )); do
                log "${BOLD}${library_keys[$i]}. ${library_names[$i]}:${NC}\n  ${library_descs[$i]}\n"

            done
            choices=""
        else
            # Display library names without descriptions
            for (( i=0; i<${#library_keys[@]}; i++ )); do
                log "${library_keys[$i]}. ${library_names[$i]}"
            done
        fi
        log ""

        if [[ "$choices" != "help" ]]; then
            log "Type 'help' to see more detailed description for each library.\n"
            user_prompt "Enter a comma-separated list of libraries you wish to include (blank for all): " choices
        fi

        # Check for 'help' input
        if [[ "$choices" == "help" ]]; then
            continue
        fi

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


library_numbers_to_names() {
    local library_numbers=$1
    local project_type=$2
    local library_names=""
    local IFS=','
    local libraries=()

    if [ "$project_type" == "ANGULAR" ]; then
        libraries=("${angular_libraries[@]}")
    elif [ "$project_type" == "REACT" ]; then
        libraries=("${react_libraries[@]}")
    elif [ "$project_type" == "SPRING" ]; then
        libraries=("${spring_libraries[@]}")
    elif [ "$project_type" == "QUARKUS" ]; then
        libraries=("${quarkus_libraries[@]}")
    else 
        log_error "Invalid service type: $project_type"
        exit 1
    fi

    # Iterate libs first to ensure display consistency irregardless of user choice order
    for lib in "${libraries[@]}"; do
        IFS=':' read -r key value <<< "$lib"
        for number in $library_numbers; do
            if [ "$key" == "$number" ]; then
                if [ -n "$library_names" ]; then
                    library_names+=", "
                fi
                library_names+="$value"
                break
            fi
        done
    done

    # Remove the trailing comma and echo the result
    echo "${library_names%, }"
}


library_numbers_to_names_and_versions() {
    local library_numbers=$1
    local project_type=$2
    local library_names_and_versions=()
    local IFS=','
    local libraries=()

    if [ "$project_type" == "ANGULAR" ]; then
        libraries=("${angular_libraries[@]}")
    elif [ "$project_type" == "REACT" ]; then
        libraries=("${react_libraries[@]}")
    elif [ "$project_type" == "SPRING" ]; then
        libraries=("${spring_libraries[@]}")
    elif [ "$project_type" == "QUARKUS" ]; then
        libraries=("${quarkus_libraries[@]}")
    else 
        log_error "Invalid service type: $project_type"
        exit 1
    fi

    for number in $library_numbers; do
        for lib in "${libraries[@]}"; do
            IFS=':' read -r key name version <<< "$lib"
            if [ "$key" == "$number" ]; then
                library_names_and_versions+=("${name}:${version}")
                break
            fi
        done
    done

    # Echo the array elements
    echo "${library_names_and_versions[@]}"
}

log_selected_libraries() {
    local selected_libraries="$1"
    if [ -z "$selected_libraries" ]; then
        log "No additional libraries selected "
    else
        log "Libraries selected: $selected_libraries "
    fi
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

    # Check if the user wants to exit the application
    if [[ $_input == "exit" ]]; then
        cleanup
        exit 0
    fi

    # Assign the input to the variable whose name was passed
    eval "$_varname=\$_input"
}

exec_cmd() {
    local COMMAND=$1

    if [ "$verbose" = true ]; then
        log_verbose "Executing command: ${COMMAND}"
        eval "${COMMAND}"
    else
        eval "${COMMAND}" >/dev/null
    fi

    if [ $? -ne 0 ]; then
        log_major_step "Error executing command: ${COMMAND}"
        cleanup
        exit 1
    fi
}

# Doesn't exit when error
exec_cmd_tol() {
    local COMMAND=$1

    if [ "$verbose" = true ]; then
        eval "$COMMAND"
    else
        eval "$COMMAND" > /dev/null
    fi
}

cleanup() {
    if cd "$START_DIR"; then
        log_warning "\nCleaning up after errors...\n"
        rm -rf "$PROJECT_DIR"
        rm -rf "$PROJECT_DIR-api"
        rm $LOCAL_JAR_NAME
    else
        log_error "Failed to change to START_DIR. Cleanup aborted to prevent accidental data loss."
    fi

    exit 1
}

