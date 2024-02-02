
assert_angular_prerequisites() {
    # Check if Node, npm and git are present
    assert_node_is_present
    assert_npm_is_present
    assert_git_is_present

    # Check if the Node version is compatible with the Angular version
    local angular_version=$1
    local node_version=$(node --version)
    local node_major_version=$(get_major_version $node_version)

    angular_major_version=$(get_major_version "$angular_version_from_package")
    node_version_range=$(get_node_version_range "$angular_major_version")
    log "Required node version range: $node_version_range \n"

    if is_node_version_in_range "$node_version_range" "$node_major_version"; then
        log_verbose "Compatible Node version found"
    else
        log_warning "Your setup is using Node version $node_version, which is not compatible with Angular $angular_version. "
        log_error "Booty currently requires one of the following compatible versions of Node: $node_version_range in order to function. \n"
        log ""
        log "Suggestion:"
        log "You can use nvm to install multiple versions of Node and switch between them."
        log "Otherwise, if you installed Node using Homebrew, you could run 'brew upgrade node' to upgrade to the latest version."
        log "Visit ${UNDERLINE}https://angular.io/guide/versions#actively-supported-versions${NC} for more information."
        log ""

        exit 1
    fi
    
    #log versions of each of the above
    log "Node version: $(node --version)"
    log "NPM version: $(npm --version)"
    log "Git version: $(git --version)"
}

assert_spring_boot_prerequisites() {
    assert_java_is_present
    assert_git_is_present

    local minimum_java_version_required=$1
    local java_version=$(java -XshowSettings:properties -version 2>&1 | grep 'java.runtime.version' | awk '{print $3}' | cut -d '.' -f1 | cut -d '-' -f1 | cut -d '+' -f1)    
    
    assert_java_version_greater_than_minimum_required "$java_version" "$minimum_java_version_required" "Spring Boot"    
    # if [ ]; then
    #     log_error "Your local Java version $java_version is not compatible with the required to work with a Spring Boot project created using this tool."
    #     log "Please install Java $minimum_java_version_required or higher and try again."
    #     exit 1
    # fi

    #log versions of each of the above
    log ""
    log "Java version: $(java --version)"
    log "Git version: $(git --version)"

}

assert_quarkus_prerequisites() {
    assert_java_is_present
    assert_git_is_present

    local java_version=$(java -XshowSettings:properties -version 2>&1 | grep 'java.runtime.version' | awk '{print $3}' | cut -d '.' -f1 | cut -d '-' -f1 | cut -d '+' -f1)    
    local minimum_java_version_required=$QUARKUS_MIN_JAVA_VERSION
    local project_type="Quarkus"

    assert_java_version_greater_than_minimum_required "$java_version" "$minimum_java_version_required" "$project_type"

    log ""
    log "Java version: $(java --version)"
    log "Git version: $(git --version)"
}

assert_qa_prerequisites() {
    assert_node_is_present
    assert_npm_is_present
    assert_git_is_present

    local node_version=$(node --version)
    local node_major_version=$(get_major_version $node_version)
    local required_major_node_version=$(get_qa_required_major_node_version)
    #TODO: assert version is latest


    
}

assert_java_version_greater_than_minimum_required() {
    local java_version=$1
    local minimum_java_version_required=$2
    local project_type=$3

    if [ "$java_version" -lt "$minimum_java_version_required" ]; then
        log_error "Your local Java version $java_version is not compatible with the required to work with a ${project_type} project created using this tool."
        log "Please install Java $minimum_java_version_required or higher and try again."
        exit 1
    fi

    log_verbose "Java version $java_version is compatible with the required to work with a ${project_type} project."
}

assert_react_prerequisites() {
    assert_node_is_present
    assert_npm_is_present
    assert_git_is_present
}

assert_node_is_present() {
    log_verbose "Checking for Node..."
    if ! command -v node &> /dev/null
    then
        log_error "Node could not be found. Please install Node and try again."
        exit 1
    fi
}

assert_npm_is_present() {
    log_verbose "Checking for NPM..."
    if ! command -v npm &> /dev/null
    then
        log_error "NPM could not be found. Please install NPM and try again."
        exit 1
    fi
}

assert_git_is_present() {
    log_verbose "Checking for Git..."
    if ! command -v git &> /dev/null
    then
        log_error "Git could not be found. Please install Git and try again."
        exit 1
    fi
}

assert_java_is_present() {
    log_verbose "Checking for Java..."
    if ! command -v java &> /dev/null
    then
        log_error "Java could not be found. Please install Java and try again."
        exit 1
    fi
}


# Function to get major version from a version string
get_major_version() {
    echo $1 | cut -d '.' -f 1 | tr -dc '0-9'
}

# Function to check if Node version is in range
is_node_version_in_range() {
    IFS=' || ' read -ra versions <<< "$1"
    for version in "${versions[@]}"; do
        version=$(get_major_version "$version")
        if [[ "$2" == "$version" ]]; then
            return 0
        fi
    done
    return 1
}

# Function to get compatible Node version range for an Angular version
get_node_version_range() {
    local angular_major_version=$(get_major_version "$1")
    for i in "${!angular_versions[@]}"; do
        if [[ "${angular_versions[$i]}" == *"$angular_major_version"* ]]; then
            echo "${node_versions[$i]}"
            return
        fi
    done
    echo "Version not found"
}

# get_qa_required_major_node_version() {
    
# }