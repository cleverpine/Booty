source ./git_commands.sh

export RED='\033[31m'
export GREEN='\033[32m'
export PURPLE='\033[35m'
export NC='\033[0m' # No Color

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
    read -p "Enter a specific SSH directory (leave blank for default): " SSH_DIR
    if [ -z "$SSH_DIR" ]; then
        log "Using default SSH directory."
        SSH_DIR="$HOME/.ssh/id_rsa"
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
    log "----------------------------------------------------------------------------------------------------------------------------"
    log "${PURPLE}$1${NC}"
    log "----------------------------------------------------------------------------------------------------------------------------"
    log ""
}