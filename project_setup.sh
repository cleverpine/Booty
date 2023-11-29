# Function to handle SSH directory and project setup
handle_project_setup() {
    local service_type=$1
    handle_git_setup "$service_type"
    # call setup tool for backend or frontend
    
}

handle_git_setup() {
    local service_type=$1

    # Ask for SSH directory configuration
    read -p "Enter a specific SSH directory or leave blank for default: " ssh_dir
    if [ -z "$ssh_dir" ]; then
        echo "Using default SSH directory."
    else
        echo "Using SSH directory: $ssh_dir..."
        # Here, you can add commands to configure SSH with the specified directory.
    fi

    # Prompt for remote repository URL to clone
    read -p "Enter a remote Git repository URL to clone (or leave blank to create a new project): " git_clone_url
    if [ ! -z "$git_clone_url" ]; then
        # Clone the repository
        git clone "$git_clone_url"
        echo "Git repository cloned from $git_clone_url"
    else
        # Prompt for project name and create a new project
        read -p "Enter the name for your $service_type project: " project_name
        echo "Setting up $service_type project named $project_name..."

        # Initialize Git repository
        mkdir "$project_name"
        cd "$project_name"
        git init

        # Optionally, you can ask for a remote URL to add to the new repository
        read -p "Enter the remote Git repository URL for your new project (or leave blank if none): " git_repo_url
        if [ ! -z "$git_repo_url" ]; then
            git remote add origin "$git_repo_url"
            echo "Git repository initialized with remote URL: $git_repo_url"
        else
            echo "Git repository initialized without a remote URL."
        fi
    fi
}
