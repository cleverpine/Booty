
prompt_project_name() {
    while true; do
        log ""
        user_prompt "Enter name for your $service_type project: " PROJECT_DIR

        if [ -z "$PROJECT_DIR" ]; then
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
    local library_names=()
    local library_descs=() # Array for library descriptions

    if [ "$1" == "FE" ]; then
        libraries=("0:none" "${frontend_libraries[@]}")
        library_descs=("No additional libraries will be installed" "${frontend_libs_descriptions[@]}")
    elif [ "$1" == "SPRING" ]; then
        libraries=("0:none" "${backend_libraries[@]}")
        library_descs=("No additional libraries will be installed" "${backend_libs_descriptions[@]}")
    elif [ "$1" == "QUARKUS" ]; then
        libraries=("0:none" "${quarkus_libraries[@]}")
        library_descs=("No additional libraries will be installed" "${quarkus_libraries_descriptions[@]}")
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
            user_prompt "Enter a comma-separated list of libraries you wish to include (leave blank for all): " choices
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


library_numbers_to_names_and_versions() {
    local library_numbers=$1
    local service_type=$2
    local library_names_and_versions=()
    local IFS=','
    local libraries=()

    if [ "$service_type" == "FE" ]; then
        libraries=("${frontend_libraries[@]}")
    elif [ "$service_type" == "SPRING" ]; then
        libraries=("${backend_libraries[@]}")
    elif [ "$service_type" == "QUARKUS" ]; then
        libraries=("${quarkus_libraries[@]}")
    else 
        log_error "Invalid service type: $service_type"
        return 1
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

exec_cmd() {
    local COMMAND=$1

    if [ "$verbose" = 1 ]; then
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

    if [ "$verbose" = 1 ]; then
        eval "$COMMAND"
    else
        eval "$COMMAND" > /dev/null
    fi
}

cleanup() {
    if cd "$START_DIR"; then
        if [ -n "$PROJECT_DIR" ] && [ -d "$PROJECT_DIR" ]; then
            log_warning "Cleaning up after errors...\n"
            rm -rf -- "$PROJECT_DIR"
        fi
    else
        log_error "Failed to change to START_DIR. Cleanup aborted to prevent accidental data loss."
    fi
}