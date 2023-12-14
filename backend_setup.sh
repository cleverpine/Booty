source ./common.sh
source ./git_commands.sh

setup_backend() {
  echo ""
  echo "Please select the type of frontend you want to set up:"
  echo "1. Spring Boot"
  echo "2. Quarkus"
  echo ""
  read -p "Enter the number of your choice (or type 'help' for more options): " choice
  
    case "$choice" in
        1)
        setup_spring_boot
        ;;
        2)
        log "Not implemented yet."
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

display_backend_library_options() {
    log_major_step "Choose additional libraries to install"

    for ((i=0; i<${#backend_libraries[@]}; i++)); do
        echo "$((i+1)). ${backend_libraries[i]}"
    done
    log ""
    read -p "Enter a comma-separated list of all libraries you wish to include: " choices

    # Check if input is empty or 'n'
    if [[ -z "$choices" || "$choices" == "n" ]]; then
        log "No additional libraries selected. Exiting PineBoot."
        return 0
    fi

    # Convert choices into an array
    IFS=',' read -r -a choice_array <<< "$choices"

    # Initialize an empty string to accumulate package names
    npm_packages=""

    for choice in "${choice_array[@]}"
    do
        index=$((choice - 1))
        if [ "$index" -ge 0 ] && [ "$index" -lt "${#backend_libraries[@]}" ]; then
            npm_packages+="${backend_libraries[index]} "
        else
            log "Invalid choice: $choice. Please try again."
        fi
    done

    # Check if any package is selected
    if [ -n "$npm_packages" ]; then
        log "Installing selected packages..."
        npm install $npm_packages --save
    else
        log "No valid libraries selected."
    fi
}


setup_spring_boot() {
    log_major_step "Checking prerequisites..."
    assert_backend_prerequisites
    log_major_step "Prerequisites met! Begin project setup."

}


assert_backend_prerequisites() {
    local java_version git_version

    # 1. Check if Java is installed
    if ! command -v java &> /dev/null
    then
        log "Java could not be found. Please install Java 11 or higher and try again."
        exit 1
    fi

    # Get Java version
    java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')

    # 2. Check if Git is installed
    if ! command -v git &> /dev/null
    then
        log "Git could not be found. Please install Git and try again."
        exit 1
    fi

    # Get Git version
    git_version=$(git --version | awk '{print $3}')

    # Display versions
    log "Java version: $java_version"
    log "Git version: $git_version"
}
