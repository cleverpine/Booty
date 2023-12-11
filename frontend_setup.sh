source ./common_setup.sh


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
        help)
        echo "Help is on the way!"
        ;;
        *)
        echo "Invalid choice. Please try again."
        ;;
    esac
}


setup_angular() {
    setup_git "Angular"
    SKELETON_REPO="git@github.com:cleverpine/angular-skeleton.git"
    # SKELETON_DIR="angular-skeleton"

    log_major_step "Cloning Angular skeleton repository..."
    # Clone the Angular skeleton repository
    git clone $SKELETON_REPO $PROJECT_DIR

    log_major_step "Changing work dir to $SKELETON_DIR..."
    echo "Project dir is $PROJECT_DIR"
    cd $PROJECT_DIR
    git remote remove origin

    # Check if git_clone_url is provided and add it as a remote
    if [ -n "$GIT_CLONE_URL" ]; then
        log_major_step "Adding provided Git URL as a remote..."
        git remote add origin $GIT_CLONE_URL
    fi

    # Merge skeleton with angular CLI generated project
    generate_new_project $PROJECT_DIR $SKELETON_DIR
}


generate_new_project() {
    if [ -z "$PROJECT_DIR" ]; then
        log "Missing arguments for generate_new_project"
        return 1
    fi

    log_major_step "Clean installing project..."
    npm ci
    log_major_step "Updating Skeleton with latest Angular versions..."
    ng update @angular/core @angular/cli --force
    git checkout --orphan new-main
    git add -A && git commit -m "Initial commit with updated structure"
    ng_update_all_packages

    log_major_step "Renaming skeleton project to $PROJECT_DIR..."
    # Rename project in specific files
    sed -i "" "s/angular-skeleton/$PROJECT_DIR/g" package.json
    sed -i "" "s/angular-skeleton/$PROJECT_DIR/g" angular.json
    sed -i "" "s/angular-skeleton/$PROJECT_DIR/g" docker-compose.yml
    sed -i "" "s/angular-skeleton/$PROJECT_DIR/g" README.md

    # Regenerate package-lock.json
    log_major_step "Regenerating package-lock.json..."
    rm -rf node_modules
    rm -f package-lock.json
    npm install

    # Remove skeleton remote repository link
    git remote remove origin
    git add . && git commit -m "Project $PROJECT_DIR setup complete"

    display_library_options
}


ng_update_all_packages() {
    update_list=$(ng update | grep 'ng update @angular' 2>&1)
    package_array=()  # Initialize an empty array to store package names

    IFS=$'\n' # Split output into lines
    for line in $update_list; do
        if [[ $line == *'->'* ]]; then
            package_name=$(echo "$line" | awk '{print $1}')
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


display_library_options() {
    # Declare an associative array for package names
    declare -A packages
    packages=(
        [1]="cp-lht-header"
        [2]="cp-lht-sidebar"
        [3]="cp-lht-tile"
        [4]="primeng"
        [5]="syncfusion"
        [6]="ng-openapi-gen"
    )

    echo "Please select the libraries you want to install (leave blank or enter 'n' to skip):"
    for key in "${!packages[@]}"; do
        echo "$key. ${packages[$key]}"
    done
    echo ""
    read -p "Enter a comma-separated list of all libraries you wish to include: " choices

    # Check if input is empty or 'n'
    if [[ -z "$choices" || "$choices" == "n" ]]; then
        echo "No additional libraries selected. Exiting."
        return
    fi

    # Convert choices into an array
    IFS=',' read -r -a choice_array <<< "$choices"

    # Initialize an empty string to accumulate package names
    npm_packages=""

    for choice in "${choice_array[@]}"
    do
        package_name=${packages[$choice]}
        if [ -n "$package_name" ]; then
            npm_packages+="$package_name "
        else
            echo "Invalid choice: $choice. Please try again."
        fi
    done

    # Check if any package is selected
    if [ -n "$npm_packages" ]; then
        echo "Installing selected packages..."
        npm install $npm_packages --save
    else
        echo "No valid libraries selected."
    fi
}