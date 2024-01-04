
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
        setup_angular
        ;;
        2)
        setup_react
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


setup_angular() {
    local START_DIR=$(pwd)
    local SKELETON_REPO=$SSH_ANGULAR_SKELETON_CLONE_URL
    local PROJECT_DIR
    local SSH_DIR
    local GIT_REMOTE_URL
    local LIBRARIES_CHOICE

    log_verbose "Verbose mode activated."

    # 0. Fetch the Angular version used in the skeleton project 
    local angular_version_from_package=$(get_angular_version_from_package)

    # 1. Check prerequisites for setting up an Angular Project
    log_major_step "Checking prerequisites..."
    assert_angular_prerequisites $angular_version_from_package
    log_major_step "Prerequisites met! Begin project setup."

    # 2. Prompt for project name
    prompt_project_name PROJECT_DIR

    # 3. Configure SSH directory 
    configure_ssh SSH_DIR

    # 4. Configure Git remote repository (optional)
    prompt_git_remote GIT_REMOTE_URL
    
    # 5. Select all cp libraries you want to include
    prompt_cp_libraries "FE" LIBRARIES_CHOICE

    log_major_step "Using the following configuration:"
    log "Project name: $PROJECT_DIR"
    log "SSH directory: $SSH_DIR"
    log "Git remote URL: $GIT_REMOTE_URL"
    log "Libraries to install: $LIBRARIES_CHOICE"

    # 6. Clone the Angular skeleton repository
    log_major_step "Cloning Angular skeleton repository..."
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


generate_new_project() {
    local PROJECT_DIR=$1
    local CP_LIBRARIES_TO_INSTALL=$2

    if [ -z "$PROJECT_DIR" ]; then
        log "Missing arguments for generate_new_project"
        return 1
    fi

    # 1. Rename skeleton project to the project name provided
    log_major_step "Renaming skeleton project to $PROJECT_DIR..."
    sed -i "" "s/angular-skeleton/$PROJECT_DIR/g" package.json
    sed -i "" "s/angular-skeleton/$PROJECT_DIR/g" package-lock.json
    sed -i "" "s/angular-skeleton/$PROJECT_DIR/g" angular.json
    sed -i "" "s/angular-skeleton/$PROJECT_DIR/g" docker-compose.yml
    sed -i "" "s/angular-skeleton/$PROJECT_DIR/g" README.md

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


install_additional_libraries() {
    local LIBRARIES_CHOICE=$1

    # Convert choices into an array
    IFS=',' read -r -a LIBRARIES_CHOICE_ARRAY <<< "$LIBRARIES_CHOICE"

    local npm_packages=()
    local successful_packages=()
    local failed_packages=()
    local error_logs=()

    for choice in "${LIBRARIES_CHOICE_ARRAY[@]}"
    do
        for lib in "${frontend_libraries[@]}"; do
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
            error_log=$(npm install "$package" --save 2>&1 >/dev/null)
            if [ $? -eq 0 ]; then
                successful_packages+=("$package")
            else
                failed_packages+=("$package")
                error_logs+=("$error_log")
            fi
        done
    else
        log "No additional libraries selected for install."
    fi


    # Display the report
    log_major_step "Summary of additional library installations"
    printf -- "\n- Successfully added libraries:\n"
    for package in "${successful_packages[@]}"; do
        printf "    - %b%s%b\n" "${GREEN}${BOLD}" "$package" "${NC}"
    done

    printf -- "\n\n- Errors installing the following libraries:\n"
    for i in "${!failed_packages[@]}"; do
        printf "    - %b%s%b\n" "${RED}${BOLD}" "${failed_packages[$i]}" "${NC}"
        printf '%s\n' "$(sed 's/^/\t/' <<< "${error_logs[$i]}")"
    done
}


get_angular_version_from_package() {
    log_verbose "Fetching Angular version from package... $RAW_ANGULAR_SKELETON_PACKAGE_JSON"
    local angular_version_from_package=$(curl -s $RAW_ANGULAR_SKELETON_PACKAGE_JSON | awk -F'[:,]' '/"@angular\/core"/ {gsub(/^[ \t"]+|[ \t",]+$/, "", $2); print $2}')
    log_verbose "Angular version from package: $angular_version_from_package"
    echo $angular_version_from_package
}