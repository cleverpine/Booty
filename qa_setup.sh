

setup_qa() {
    local SKELETON_REPO=$QA_SKELETON_REPO
    local START_DIR=$(pwd)
    local PROJECT_DIR
    local SSH_DIR
    local GIT_REMOTE_URL
    local LIBRARIES_CHOICE

    log_verbose "Verbose mode activated."
    
    #1 Check prerequisites for setting up a Project
    # assert_qa_prerequisites

    #2 Prompt for project name
    prompt_project_name PROJECT_DIR

    #3 Configure SSH directory
    configure_ssh SSH_DIR

    #4. Configure Git remote repository (optional)
    prompt_git_remote GIT_REMOTE_URL

    log_major_step "Using the following configuration:"
    log "Project name: $PROJECT_DIR"
    log "SSH directory: $SSH_DIR"
    log "Git remote URL: $GIT_REMOTE_URL"

    #5. Clone the skeleton repository
    log_major_step "Cloning the QA skeleton repository..."
    GIT_SSH_COMMAND="ssh -i $SSH_DIR" git clone $SKELETON_REPO $PROJECT_DIR
    cd $PROJECT_DIR

    #7. Setup a fresh git repository
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


    #8. Running npm ci to verify the project setup is working
    log_major_step "Running npm ci to verify the project setup is working..."
    exec_cmd "npm ci"


}