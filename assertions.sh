source ./common.sh

# Function that validates that the user has the prerequisites installed to setup an Angular project - Node, NPM, Angular CLI and Git
assert_angular_prerequisites() {
    assert_node_is_present
    assert_npm_is_present
    assert_git_is_present

    #log versions of each of the above
    log ""
    log "Node version: $(node --version)"
    log "NPM version: $(npm --version)"
    log "Git version: $(git --version)"
}

assert_spring_boot_prerequisites(){
    assert_java_is_present
    assert_git_is_present

    #log versions of each of the above
    log ""
    log "Java version: $(java --version)"
    log "Git version: $(git --version)"

}

assert_node_is_present() {
    log "Checking for Node..."
    if ! command -v node &> /dev/null
    then
        log_error "Node could not be found. Please install Node and try again."
        exit 1
    fi
}

assert_npm_is_present(){
    log "Checking for NPM..."
    if ! command -v npm &> /dev/null
    then
        log_error "NPM could not be found. Please install NPM and try again."
        exit 1
    fi
}

assert_git_is_present(){
    log "Checking for Git..."
    if ! command -v git &> /dev/null
    then
        log_error "Git could not be found. Please install Git and try again."
        exit 1
    fi
}

assert_java_is_present(){
    log "Checking for Java..."
    if ! command -v java &> /dev/null
    then
        log_error "Java could not be found. Please install Java and try again."
        exit 1
    fi
}