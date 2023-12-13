git_add_commit_package_json() {
    local commit_message=$1

    if [ -z "$commit_message" ]; then
        log "Error: Missing commit message for git_commit_package_json"
        return 1
    fi

    git add package.json package-lock.json
    git commit -m "$commit_message"
}