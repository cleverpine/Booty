setup_git() {
    local service_type=$1
    local git_clone_url
    local project_dir

    if [ -z "$service_type" ]; then
        log "Error: Missing service type for setup_git"
        return 1
    fi

    # Ask for SSH directory configuration
    setup_ssh 

    # Prompt for remote repository URL to clone
    read -p "Paste a clone URL or leave blank for local git repository only: " git_clone_url
    if [ -n "$git_clone_url" ]; then
        # Clone the repository
        project_dir=$(basename -s .git "$git_clone_url")
        if ! git clone "$git_clone_url" >&2; then
            log "Error: Failed to clone repository from $git_clone_url"
            return 1
        fi
        echo "$project_dir"
    else
        # Prompt for project name and create a new project
        read -p "Enter directory name for your $service_type project: " project_dir
        if [ -z "$project_dir" ]; then
            log "Error: No directory name provided"
            return 1
        fi

        if ! mkdir "$project_dir" >&2; then
            log "Error: Failed to create directory $project_dir"
            return 1
        fi
        if ! cd "$project_dir" >&2; then
            log "Error: Failed to change directory to $project_dir"
            return 1
        fi
        if ! git init >&2; then
            log "Error: Failed to initialize git repository in $project_dir"
            return 1
        fi
        cd .. >&2
        echo "$project_dir"
    fi
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