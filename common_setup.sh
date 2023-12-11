export PROJECT_DIR=""
export GIT_CLONE_URL=""


setup_git() {
    local service_type=$1

    if [ -z "$service_type" ]; then
        log "Error: Missing service type for setup_git"
        return 1
    fi

     read -p "Enter name for your $service_type project: " PROJECT_DIR

     if [ -z "$PROJECT_DIR" ]; then
        log "Error: No directory name provided"
        return 1
    fi

    # Ask for SSH directory configuration
    setup_ssh 

    # Prompt for remote repository URL to clone
    read -p "Paste a clone URL (leave blank if none) " GIT_CLONE_URL

    echo "$PROJECT_DIR"
}


setup_ssh() {
    read -p "Enter a specific SSH directory or leave blank for default: " ssh_dir
    if [ -z "$ssh_dir" ]; then
        log "Using default SSH directory."
    else
        log "Using SSH directory: $ssh_dir..."
        # Here, you can add commands to configure SSH with the specified directory.
    fi
}


log() {
    >&2 echo $1

}


log_major_step() {
    log ""
    log "--------------------------------------------------------------"
    log "$1"
    log "--------------------------------------------------------------"
    log ""
}