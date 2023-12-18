source ./git_commands.sh

export RED='\033[31m'
export GREEN='\033[32m'
export PURPLE='\033[35m'
export NC='\033[0m' # No Color

declare -A backend_libraries=(
    [1]="cp-spring-jpa-specification-resolver"
    [2]="cp-spring-error-util"
    [3]="cp-virava-spring-helper"
    [4]="cp-jpa-specification-resolver"
    [5]="cp-logging-library"
)

declare -A frontend_libraries=(
    [1]="cp-lht-header"
    [2]="cp-lht-sidebar"
    [3]="cp-lht-tile"
    [4]="primeng"
    [5]="syncfusion"
    [6]="ng-openapi-gen"
)

prompt_project_name() {
    read -p "Enter name for your $service_type project: " PROJECT_DIR

    if [ -z "$PROJECT_DIR" ]; then
        log_error "You must select a project name."
        prompt_project_name
    else
        echo "$PROJECT_DIR"
    fi
}

prompt_clone_url() {
    # Prompt for remote repository URL to clone. If left blank, no remote will be set
    read -p "Paste a clone URL (leave blank if none) " GIT_CLONE_URL

    echo "$GIT_CLONE_URL"
}


configure_ssh() {
    read -p "Enter a specific SSH directory (leave blank for default): " SSH_DIR
    if [ -z "$SSH_DIR" ]; then
        log "Using default SSH directory."
        SSH_DIR="$HOME/.ssh/id_rsa"
    else
        log "Using SSH directory: $SSH_DIR..."
        # Here, you can add commands to configure SSH with the specified directory.
    fi

    echo "$SSH_DIR"
}

prompt_cp_libraries() {
    # If $1 is "FE", then display frontend libraries, else display backend libraries
    local available_libraries
    if [ "$1" == "FE" ]; then
        available_libraries=("${!frontend_libraries[@]}")
    else
        available_libraries=("${!backend_libraries[@]}")
    fi

    log_major_step "Choose additional libraries to install"
    log "Available libraries: "
    for key in "${available_libraries[@]}"; do
        if [ "$1" == "FE" ]; then
            log "   $key. ${frontend_libraries[$key]}"
        else
            log "   $key. ${backend_libraries[$key]}"
        fi
    done
    log ""
    read -p "Enter a comma-separated list of all libraries you wish to include (leave blank for none): " choices

    log "$choices"
    echo "$choices"
}

comma_separated_choice_to_array() {
    local IFS=',' 
    read -r -a array <<< "$1"
    echo "${array[@]}"
}


log() {
    >&2 echo -e $1

}

log_error() {
    log "${RED}$1${NC}"
}


log_major_step() {
    log ""
    log "----------------------------------------------------------------------------------------------------------------------------"
    log "${PURPLE}$1${NC}"
    log "----------------------------------------------------------------------------------------------------------------------------"
    log ""
}

library_numbers_to_names() {
    local library_numbers=$1
    local service_type=$2
    local library_names=""
    local IFS=','
    local library_source=()

    if [ "$service_type" == "FE" ]; then
        for number in $library_numbers; do
            library_names+="${frontend_libraries[$number]}, "
        done
    elif [ "$service_type" == "BE" ]; then
        for number in $library_numbers; do
            library_names+="${backend_libraries[$number]}, "
        done
    else 
        log_error "Invalid service type: $service_type"
        exit 1
    fi

    # Remove the trailing comma and echo the result
    echo "${library_names%, }"
}