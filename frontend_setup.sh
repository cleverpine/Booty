
# Global variables
FRAMEWORK=""

setup_frontend() {
  echo ""
  echo "Please select the type of frontend you want to set up:"
  echo "1. Angular"
  echo "2. React"
  echo ""
  local choice
  user_prompt "Enter the number of your choice (or type 'help' for more options): " choice

    case "$choice" in
        1)
        FRAMEWORK="ANGULAR"
        setup_frontend_project $SSH_ANGULAR_SKELETON_CLONE_URL
        ;;
        2)
        FRAMEWORK="REACT"
        setup_frontend_project $SSH_REACT_SKELETON_CLONE_URL
        ;;
        exit)
        log "Exiting Booty."
        exit 0
        ;;
        help)
        log "Help is on the way!"
        ;;
        *)
        log "Invalid choice. Please try again."
        ;;
    esac
}

setup_frontend_project() {
    local SKELETON_REPO=$1
    local START_DIR=$(pwd)
    local PROJECT_DIR
    local SSH_DIR
    local GIT_REMOTE_URL
    local LIBRARIES_CHOICE

    # 1. Check prerequisites for setting up a Project
    log_verbose "Verbose mode activated."
    assert_prerequisites
    log_major_step "Prerequisites met! Begin project setup."

    # 2. Prompt for project name
    prompt_project_name PROJECT_DIR

    # 3. Configure SSH directory 
    configure_ssh SSH_DIR

    # 4. Configure Git remote repository (optional)
    prompt_git_remote GIT_REMOTE_URL

    # 5. Select all cp libraries you want to include
    prompt_cp_libraries $FRAMEWORK LIBRARIES_CHOICE
    
    log_major_step "Using the following configuration:"
    log "Project name: $PROJECT_DIR"
    log "SSH directory: $SSH_DIR"
    log "Git remote URL: $GIT_REMOTE_URL"
    log_selected_libraries "$LIBRARIES_CHOICE" "FE"

    # 6. Clone the skeleton repository
    log_major_step "Cloning ${FRAMEWORK} skeleton repository..."
    GIT_SSH_COMMAND="ssh -i ${SSH_DIR}" git clone $SKELETON_REPO $PROJECT_DIR
    cd $PROJECT_DIR

    # 7. Setup a fresh git repository
    log_major_step "Setting up a fresh git repository..."
    if [ "$(basename $(pwd))" != "$PROJECT_DIR" ]; then
        log_error "Current directory is not the project directory. Exiting..."
        exit 1
    fi

    log_verbose "Removing .git directory..."
    exec_cmd "rm -rf .git"
    log_verbose "Initializing new git repository with default branch main..."
    exec_cmd "git init -b main"

    if [ -n "$GIT_REMOTE_URL" ]; then
        log_major_step "Adding provided Git URL as a remote..."
        exec_cmd "git remote add origin $GIT_REMOTE_URL"
    fi

    # 8. Generate a new project from the skeleton
    generate_new_project $PROJECT_DIR $LIBRARIES_CHOICE
}

assert_prerequisites() {
    case "$FRAMEWORK" in 
        "ANGULAR")
        local angular_version_from_package=$(get_angular_version_from_package)
        assert_angular_prerequisites $angular_version_from_package
        ;;
        "REACT")
        # Not validating the react version against anything, as it is not necessary?
        assert_react_prerequisites
        ;;
    esac
}

generate_new_project() {
    local PROJECT_DIR=$1
    local CP_LIBRARIES_TO_INSTALL=$2

    if [ -z "$PROJECT_DIR" ]; then
        log "Missing arguments for generate_new_project"
        return 1
    fi

    # 1. Rename skeleton project to the project name provided
    log_major_step "Renaming skeleton project to $PROJECT_DIR..."
    rename_skeleton_files $PROJECT_DIR

    # 2. Perform a clean install of the skeleton project
    log_major_step "Running npm ci..."
    #if verbose disabled, silence npm ci
    exec_cmd "npm ci"

    # 3. Install any libraries selected by the user
    log_major_step "Installing additional cp libraries..."
    install_additional_libraries "$CP_LIBRARIES_TO_INSTALL"

    # 4. Commit final changes
    log_major_step "Committing final touches..."
    exec_cmd "git add . && git commit -m \"Initial commit - project setup\""
    
    log_major_step "Project ${YELLOW}${PROJECT_DIR}${NC}${PURPLE} setup complete!${NC}"

    # 5. Open the project in VS Code
    if [ -x "$(command -v code)" ]; then
        log_major_step "Opening project in VS Code..."
        code . -g README.md
    fi
}

rename_skeleton_files() {
    local PROJECT_DIR=$1

    case "$FRAMEWORK" in
        "ANGULAR")
        rename_angular_skeleton_files
        ;;
        "REACT")
        rename_react_skeleton_files
        ;;
    esac
}

rename_angular_skeleton_files() {
    sed -i "" "s/angular-skeleton/$PROJECT_DIR/g" package.json
    sed -i "" "s/angular-skeleton/$PROJECT_DIR/g" package-lock.json
    sed -i "" "s/angular-skeleton/$PROJECT_DIR/g" angular.json
    sed -i "" "s/angular-skeleton/$PROJECT_DIR/g" docker-compose.yml
    sed -i "" "s/angular-skeleton/$PROJECT_DIR/g" README.md
}

rename_react_skeleton_files() {
    sed -i "" "s/react-skeleton/$PROJECT_DIR/g" package.json
    sed -i "" "s/react-skeleton/$PROJECT_DIR/g" package-lock.json
}

install_additional_libraries() {
    local LIBRARIES_CHOICE=$1

    # Convert choices into an array
    IFS=',' read -r -a LIBRARIES_CHOICE_ARRAY <<< "$LIBRARIES_CHOICE"

    local npm_packages=()
    local successful_packages=()
    local failed_packages=()
    local error_logs=()
    local libraries=()

    case "$FRAMEWORK" in
        "ANGULAR")
        libraries=("${frontend_libraries[@]}")
        ;;
        "REACT")
        libraries=("${react_libraries[@]}")
        ;;
    esac

    for choice in "${LIBRARIES_CHOICE_ARRAY[@]}"
    do
        for lib in "${libraries[@]}"; do
            IFS=':' read -r key name version <<< "$lib"
            if [ "$key" == "$choice" ]; then
                npm_packages+=("${name}@${version}")
                break
            fi
        done
    done

    # Install any libraries selected by the user
    if [ "${#npm_packages[@]}" -gt 0 ]; then
        for package in "${npm_packages[@]}"; do
            log_verbose "---------------------------------"
            log_verbose "Installing $package..."
            if [ "$verbose" = true ]; then
                exec 3>&1  # Save the current state of stdout
                error_log=$(npm install "$package" --save 2>&1 >&3)
                status=$?  # Capture the exit status
                exec 3>&-  # Close the temporary file descriptor
            else
                error_log=$(npm install "$package" --save 2>&1 >/dev/null)
                status=$?  # Capture the exit status
            fi
            printf "%s\n" "$error_log" | tee -a $ERROR_LOG_FILE

            if [ $status -eq 0 ]; then
                log_verbose "Successfully installed $package"
                successful_packages+=("$package")

                log "real $package"
                log "expected ${CP_OPENAPI_GEN_PLUGIN}"

                if is_package_openapi_plugin $package; then
                    add_openapi_gen_npm_package
                fi
                # if [[ "$package" == "${CP_OPENAPI_GEN_PLUGIN}" ]]; then
                #     add_openapi_gen_npm_package
                # fi
            else
                log_verbose "Failed to install $package"
                failed_packages+=("$package")
                error_logs+=("$error_log")
            fi
        done
    else
        log "No additional libraries selected for install."
    fi

    # Display the report
    if [ ${#successful_packages[@]} -gt 0 ] || [ ${#failed_packages[@]} -gt 0 ]; then
        log_major_step "Summary of additional library installations"
    fi

    if [ ${#successful_packages[@]} -gt 0 ]; then
        log_major_step "Summary of additional library installations"
        printf -- "- Successfully added libraries:\n"
        for package in "${successful_packages[@]}"; do
            printf "    - %b%s%b\n" "${GREEN}${BOLD}" "$package" "${NC}"
        done
    fi

    if [ ${#failed_packages[@]} -gt 0 ]; then
        log "\n- Errors installing the following libraries. You may want to install them manually:\n"
        for i in "${!failed_packages[@]}"; do
            printf "    - %b%s%b\n" "${RED}${BOLD}" "${failed_packages[$i]}" "${NC}"
            printf '%s\n' "$(sed 's/^/\t/' <<< "${error_logs[$i]}")"
        done
    fi
}

is_package_openapi_plugin() {
    local package=$1
    
    log "Real package: $package <--> Expected pattern: ${CP_OPENAPI_GEN_PLUGIN}"
    if [[ "$package" == *"${CP_OPENAPI_GEN_PLUGIN}"* ]]; then
        return 0
    else
        return 1
    fi
}


get_angular_version_from_package() {
    log_verbose "Fetching Angular version from package... $RAW_ANGULAR_SKELETON_PACKAGE_JSON"
    local angular_version_from_package=$(curl -s $RAW_ANGULAR_SKELETON_PACKAGE_JSON | awk -F'[:,]' '/"@angular\/core"/ {gsub(/^[ \t"]+|[ \t",]+$/, "", $2); print $2}')
    log_verbose "Angular version from package: $angular_version_from_package"
    echo $angular_version_from_package
}

add_openapi_gen_npm_package() {
    sed -i '' '/"scripts": {/a\'$'\n  INSERT_NEW_SCRIPT_HERE' package.json
    sed -i '' $'s/INSERT_NEW_SCRIPT_HERE/  "generate": "cp-openapi-gen-angular",\\\n/' package.json

    log_warning "Remember to configure your spec location in the config.json!"
}