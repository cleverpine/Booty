source ./common.sh
source ./git_commands.sh
source ./assertions.sh

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


setup_spring_boot() {
    local START_DIR=$(pwd)


    # 1. Check if Java and Git are installed
    log_major_step "Checking prerequisites..."
    assert_spring_boot_prerequisites
    log_major_step "Prerequisites met! Begin project setup."

    # 2. Prompt for project name
    PROJECT_DIR=$(prompt_project_name)

    # 3. Configure SSH directory
    SSH_DIR=$(configure_ssh)

    # 4. Configure Git remote repository (optional)
    GIT_CLONE_URL=$(prompt_git_remote)

    # 5. Select all cp libraries you want to include
    LIBRARIES_CHOICE=$(prompt_cp_libraries "BE")
    LIBRARIES_NAMES=$(library_numbers_to_names "$LIBRARIES_CHOICE" "BE")
    log "Selected libraries to add: $LIBRARIES_NAMES"

    # # 6. Curl java jar
    # curl <> -o cp-spring-initializr-0.0.1-SNAPSHOT.jar # TODO: Add link to jar and name

    # # 7. Create project directory
    # java -jar cp-spring-initializr-0.0.1-SNAPSHOT.jar --name=$PROJECT_DIR --includeApi=true --dependencies=$LIBRARIES_NAMES
}
