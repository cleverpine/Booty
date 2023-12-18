source ./common.sh
source ./git_commands.sh
source ./assertions.sh

setup_frontend() {
  echo ""
  echo "Please select the type of frontend you want to set up:"
  echo "1. Angular"
  echo "2. React"
  echo ""
  read -p "Enter the number of your choice (or type 'help' for more options): " choice
  
    case "$choice" in
        1)
        setup_angular
        ;;
        2)
        setup_react
        ;;
        exit)
        log "Exiting PineBoot."
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

    # 1. Check prerequisites for setting up an Angular Project
    log_major_step "Checking prerequisites..."
    assert_angular_prerequisites
    log_major_step "Prerequisites met! Begin project setup."

    local PROJECT_DIR
    local SSH_DIR
    local GIT_REMOTE_URL
    local LIBRARIES_CHOICE

    local SKELETON_REPO="git@github.com:cleverpine/angular-skeleton.git"
    
    # 2. Prompt for project name
    PROJECT_DIR=$(prompt_project_name)

    # 3. Configure SSH directory 
    SSH_DIR=$(configure_ssh)

    GIT_REMOTE_URL=$(prompt_git_remote)

    SKELETON_REPO="git@github.com:cleverpine/angular-skeleton.git"
    # SKELETON_DIR="angular-skeleton"

    # 5. Select all cp libraries you want to include
    LIBRARIES_CHOICE=$(prompt_cp_libraries "FE")

    # 6. Clone the Angular skeleton repository
    log_major_step "Cloning Angular skeleton repository..."
    echo "Skeleton repo: $SKELETON_REPO"
    echo "Project dir: $PROJECT_DIR"

    GIT_SSH_COMMAND="ssh -i ${SSH_DIR}" git clone $SKELETON_REPO $PROJECT_DIR
    cd $PROJECT_DIR

    # 7. Check if git_clone_url is provided and add it as a remote
    # if current directory is not the project directory, exit with error
    if [ "$(basename $(pwd))" != "$PROJECT_DIR" ]; then
        log_error "Current directory is not the project directory. Exiting..."
        exit 1
    fi

    git remote remove origin
    if [ -n "$GIT_REMOTE_URL" ]; then
        log_major_step "Adding provided Git URL as a remote..."
        git remote add origin $GIT_REMOTE_URL
    fi

    # install_additional_libraries $LIBRARIES_CHOICE

    # 8. Generate a new project from the skeleton using latet Angular versions
    generate_new_project $PROJECT_DIR $LIBRARIES_CHOICE

}


generate_new_project() {
    local PROJECT_DIR=$1
    local CP_LIBRARIES_TO_INSTALL=$2

    if [ -z "$PROJECT_DIR" ]; then
        log "Missing arguments for generate_new_project"
        return 1
    fi

    # 1. Perform a clean install of the skeleton project
    log_major_step "Clean installing project..."
    npm ci

    # 2. Update Angular dependencies to latest versions
    log_major_step "Updating Skeleton with latest Angular versions..."
    ng update @angular/core @angular/cli --force
    git checkout --orphan new-main
    git add -A && git commit -m "Initial commit with updated structure"
    ng_update_all_packages


    # 3. Rename skeleton project to the project name provided
    log_major_step "Renaming skeleton project to $PROJECT_DIR..."
    sed -i "" "s/angular-skeleton/$PROJECT_DIR/g" package.json
    sed -i "" "s/angular-skeleton/$PROJECT_DIR/g" angular.json
    sed -i "" "s/angular-skeleton/$PROJECT_DIR/g" docker-compose.yml
    sed -i "" "s/angular-skeleton/$PROJECT_DIR/g" README.md

    # 4. Regenerate package-lock.json
    log_major_step "Regenerating package-lock.json..."
    rm -rf node_modules
    rm -f package-lock.json
    npm install
    git_add_commit_package_json "Update latest versions of Angular dependencies"
    

    # 5. Install any libraries selected by the user
    log_major_step "Installing additional cp libraries..."
    install_additional_libraries "$CP_LIBRARIES_TO_INSTALL"
    
    # 6. Commit final changes
    log_major_step "Committing final touches..."
    git add . && git commit -m "Install additional cp libraries"

    return 0
}


ng_update_all_packages() {
    update_list=$(ng update | grep 'ng update @angular' 2>&1)
    package_array=()  # Initialize an empty array to store package names

    IFS=$'\n' # Split output into lines
    for line in "$update_list"; do
        if [[ $line == *'->'* ]]; then
            package_name=$(echo "$line" | cut -d ' ' -f 1)
            package_array+=("$package_name")  # Append the package name to the array
        fi
    done
    unset IFS

    # Construct and execute the update command if there are packages to update
    if [ ${#package_array[@]} -ne 0 ]; then
        echo "Updating all packages..."
        ng update "${package_array[@]}"
    else
        echo "No packages to update."
    fi
}

install_additional_libraries() {
    local LIBRARIES_CHOICE=$1
    log "LIBRARIES_CHOICE: $LIBRARIES_CHOICE"

    # Convert choices into an array
    IFS=',' read -r -a LIBRARIES_CHOICE_ARRAY <<< "$LIBRARIES_CHOICE"
    log "LIBRARIES_CHOICE_ARRAY: ${LIBRARIES_CHOICE_ARRAY[*]}"

    # Initialize an empty string to accumulate package names
    local npm_packages=""
    for choice in "${LIBRARIES_CHOICE_ARRAY[@]}"
    do
        local index=$((choice - 1))
        if [ "$index" -ge 0 ] && [ "$index" -lt "${#frontend_libraries[@]}" ]; then
            npm_packages+="${frontend_libraries[$index]} "
        else
            log "Invalid choice: $choice. Please try again."
        fi
    done

    log "npm_packages: $npm_packages"
    # Install any libraries selected by the user
    if [ -n "$npm_packages" ]; then
        log_major_step "Installing selected packages..."
        npm install "$npm_packages" --save
    else
        log "No additional libraries selected for install."
    fi
}
