
setup_backend() {
  echo ""
  echo "Please select the type of backend you want to set up:"
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


setup_spring_boot() {
    local START_DIR=$(pwd)


    # 1. Check if Java and Git are installed
    log_major_step "Checking prerequisites..."
    assert_spring_boot_prerequisites
    log_major_step "Prerequisites met! Begin project setup."

    # 2. Prompt for project name
    prompt_project_name PROJECT_DIR

    # 3. Configure SSH directory
    configure_ssh SSH_DIR

    # 4. Configure Git remote repository (optional)
    prompt_git_remote GIT_REMOTE_URL

    # 5. Select all cp libraries you want to include
    prompt_cp_libraries "BE" LIBRARIES_CHOICE
    LIBRARIES_NAMES=$(library_numbers_to_names "$LIBRARIES_CHOICE" "BE")

    # 6. Prompt for including Open API generator plugin
    prompt_boolean "Would you like to include Open API generator?" INCLUDE_API
    
    log_major_step "Using configuration:"
    log "Project name: $PROJECT_DIR"
    log "SSH directory: $SSH_DIR"
    log "Git remote URL: $GIT_REMOTE_URL"
    log "Libraries: $LIBRARIES_NAMES"
    log "Include api: $INCLUDE_API"

    log_major_step "Generating Spring Boot project..."

    # 7. Download cp-spring-initializr jar file
    log "Downloading 'CP-Spring-Initializr'..."
    jar_url="https://github.com/cleverpine/cp-spring-initializr/releases/download/v0.0.1/cp-spring-initializr-0.0.1.jar"
    jar_name="cp-spring-initializr.jar"

    # '-f' argument returns a non-zero exit code on HTTP error response
    # '-L' argument sets the link to download from
    # '-o' argument renames the downloaded file
    curl -f -L "$jar_url" -o "$jar_name"
    curl_status=$?

    # 8. Initialize project generation if the jar file was downloaded successfully
    if [ $curl_status -eq 0 ]; then
        log "Initializing project generation..."
        # Execute the jar file
        java -jar cp-spring-initializr.jar --name=$PROJECT_DIR --includeApi=$INCLUDE_API --dependencies=$LIBRARIES_NAMES --verbose=$verbose
        java_status=$?
    else
        log_error "'CP-Spring-Initializr' could not be downloaded!"
        # Exit if downloading the jar file failed
        exit 1
    fi

    # 9. Delete the jar file if it executed successfully
    if [ $java_status -eq 0 ]; then
        log "Successfully generated project '$PROJECT_DIR'."
    else
        log_error "'CP-Spring-Initializr' could not be executed!"
    fi

    # 10. Delete the downloaded jar file
    rm -f cp-spring-initializr.jar
}
