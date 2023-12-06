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


generate_new_project() {
    local project_dir=$1
    local project_dir_skeleton=$2
    local latest_branch=$3

    if [ -z "$project_dir" ] || [ -z "$project_dir_skeleton" ] || [ -z "$latest_branch" ]; then
        log "Error: Missing arguments for generate_new_project"
        return 1
    fi

    log_major_step "Generating latest Angular CLI project..."
    if ! npx -y -p @angular/cli@latest ng new "$project_dir" --style=scss --skip-git=true --ssr=false --skip-install=true --directory="$project_dir"; then
        log "Error: Angular CLI project generation failed"
        return 1
    fi

    cd "$project_dir" || { log "Error: Failed to change directory to $project_dir"; return 1; }

    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        git init
    fi

    git checkout -b "$latest_branch"
    git add . && git commit -m "Angular CLI project generated"

    log_major_step "Merging skeleton with latest Angular CLI project..."
    # git remote add skeleton "../$project_dir_skeleton"
    # git fetch skeleton

    # if ! git merge -X theirs --squash skeleton/main --allow-unrelated-histories; then
    #     log "Error: Merge failed"
    #     return 1
    # fi

    # if git ls-files -u | grep -q '^'; then
    #     log "Merge conflicts detected. Please resolve them before proceeding."
    #     return 1
    # else
    #     log "Merge successful. Commiting changes..."
    #     git commit -m "Merge angular-skeleton/main into latest Angular CLI"
    # fi

    # # Ensure the directory exists and is not empty before removing
    # if [ -d "../$project_dir_skeleton" ] && [ "$(ls -A "../$project_dir_skeleton")" ]; then
    #     rm -rf "../$project_dir_skeleton"
    # fi

    # log "Setup complete."
}


setup_angular() {
    local project_dir=$(setup_git "Angular")

    local project_dir_skeleton=${project_dir}-skeleton

    SKELETON_REPO="git@github.com:cleverpine/angular-skeleton.git"
    LATEST_BRANCH="latest"

    log_major_step "Cloning Angular skeleton repository..."
    # Clone the Angular skeleton repository
    git clone $SKELETON_REPO $project_dir_skeleton

    # Merge skeleton with angular CLI generated project
    generate_new_project $project_dir $project_dir_skeleton $LATEST_BRANCH
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