
setup_backend() {
  echo ""
  echo "Please select the type of backend you want to set up:"
  echo "1. Spring Boot"
  echo "2. Quarkus"
  echo ""
  read -p "Enter the number of your choice (or type 'help' for more options): " choice
  
    case "$choice" in
        1)
        setup_spring_boot
        ;;
        2)
        setup_quarkus
        ;;
        exit)
        log "Exiting Booty."
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

setup_quarkus() {
    local MAIN_DIR=$(pwd)
    local PROJECT_TYPE="QUARKUS"
    local project_dir
    local ssh_dir
    local git_remote_url
    local selected_libraries
    local selected_libraries_names_and_versions
    local should_include_api
    
    # 1. Check if Java and Git are installed
    log_major_step "Checking prerequisites..."
    assert_quarkus_prerequisites
    log_major_step "Prerequisites met! Begin project setup."
    
    # 2. Prompt for project name
    prompt_project_name project_dir

    # 3. Configure SSH directory
    configure_ssh ssh_dir

    # 4. Configure Git remote repository (optional)
    prompt_git_remote git_remote_url

    # 5. Select all cp libraries you want to include and convert them to names with versions
    prompt_cp_libraries $PROJECT_TYPE selected_libraries
    log_verbose "Libraries selected: ${selected_libraries}"
    read -a selected_libraries_names_and_versions <<< "$(library_numbers_to_names_and_versions "${selected_libraries}" $PROJECT_TYPE)"
    log_verbose "Libraries that will be installed in the quarkus project: ${selected_libraries_names_and_versions[*]}"

    # 6. Prompt for including Open API generator plugin
    prompt_boolean "Would you like to include Open API generator?" should_include_api
   

    # All the variables are set, now we can start generating the project
    log_major_step "Using configuration:"
    log "Project name: $project_dir"
    log "SSH directory: $ssh_dir"
    log "Git remote URL: $git_remote_url"
    log "Libraries: ${selected_libraries_names_and_versions[*]}"
    log "Include api: $should_include_api"


    # Step 1: Generate the project
    log_major_step "Generating Quarkus project..."
    # mvnw quarkus:create -DprojectGroupId=com.cleverpine -DprojectArtifactId=${PROJECT_DIR}
    local command="./mvnw io.quarkus.platform:quarkus-maven-plugin:3.6.4:create -DprojectGroupId=com.cleverpine -DprojectArtifactId=${project_dir} -DprojectVersion=0.0.1 -DjavaVersion=17" #TODO: java version

    if [ "$verbose" = 1 ]; then
        command="$command -X"
    else
        command="$command -q"
    fi

    eval $command
    local command_status=$?

    if [ $command_status -ne 0 ]; then
        log_error "Project generation failed!"
        return $command_status
    fi

    # Step 2: Add the libraries
    for library in "${selected_libraries_names_and_versions[@]}"; do
        add_maven_dependency $project_dir $library
    done

    # Step 3: Add the Open API generator plugin 
    # If the user prompted to include an API, add the openapi-generator-maven-plugin 7.2.0 to the pom.xml file with an input spec url, api package ${project.groupId}.api, modelPackage ${project.groupId}.model, 
    # and output directory ${project.build.directory}/generated-sources
    if [ "$should_include_api" = true ]; then
        add_open_api_generator $project_dir
    fi

    log "Successfully generated project '$project_dir'."


    # Step 4: In the created project dir, create a local git repository with the name of the project, attach the remote repository if provided, and commit the changes
    log_major_step "Setting up git repository..."
    cd $project_dir
    exec_cmd "git init -b main && git add . && git commit -m \"Quarkus setup: Initial commit\""
    if [ -n "$git_remote_url" ]; then
        exec_cmd "git remote add origin $git_remote_url"
    fi

    log_major_step "Quarkus project setup complete!"
}

add_maven_dependency() {
    local project_name=$1
    local dependency_name_version=$2
    local dependency_name=$(echo "$dependency_name_version" | cut -d ':' -f 1)
    local dependency_version=$(echo "$dependency_name_version" | cut -d ':' -f 2)

    log_verbose "Adding dependency: $dependency_name:$dependency_version to pom.xml"

    # Define the path to the pom.xml file
    local pom_file="${project_name}/pom.xml"

    # Define the dependency tag
    local dependency_tag="    <dependency>\n        <groupId>com.cleverpine</groupId>\n        <artifactId>$dependency_name</artifactId>\n        <version>$dependency_version</version>\n    </dependency>"

    # Find the line number of the last </dependencies> tag
    local dependencies_end_line=$(grep -n '</dependencies>' "$pom_file" | tail -1 | cut -d: -f1)

    if [[ -n "$dependencies_end_line" ]]; then
        # Split the file at this line and insert the dependency tag
        head -n $(($dependencies_end_line - 1)) "$pom_file" > temp
        echo -e "$dependency_tag" >> temp
        tail -n +$dependencies_end_line "$pom_file" >> temp
        mv temp "$pom_file"
    else
        log_verbose "No </dependencies> tag found in $pom_file. Dependency not added."
    fi
}

add_open_api_generator() {
    local project_name=$1
    log_verbose "Adding Open API generator plugin to pom.xml"

    local pom_file="${project_name}/pom.xml"

    # Define the plugin tag
    local plugin_tag="      <plugin>
        <groupId>org.openapitools</groupId>
        <artifactId>openapi-generator-maven-plugin</artifactId>
        <version>7.2.0</version>
        <executions>
            <execution>
                <goals>
                    <goal>generate</goal>
                </goals>
                <configuration>
                    <inputSpec><!-- TODO: Insert your API specification URL here! --></inputSpec>
                    <auth><!-- TODO: Insert your authorization token here! --></auth>
                    <apiPackage>\${project.groupId}.api</apiPackage>
                    <modelPackage>\${project.groupId}.model</modelPackage>
                    <output>\${project.build.directory}/generated-sources/</output>
                </configuration>
            </execution>
        </executions>
      </plugin>"

    # Find the line number of the last </plugins> tag
    local plugins_end_line=$(grep -n '</plugins>' "$pom_file" | tail -1 | cut -d: -f1)

    if [[ -n "$plugins_end_line" ]]; then
        # Split the file at this line and insert the plugin tag
        head -n $(($plugins_end_line - 1)) "$pom_file" > temp
        echo -e "$plugin_tag" >> temp
        tail -n +$plugins_end_line "$pom_file" >> temp
        mv temp "$pom_file"
    else
        log_verbose "No </plugins> tag found in $pom_file. Plugin not added."
    fi

    log_warning "Please make sure to add your API specification URL and authorization token to the pom.xml file!"
}







setup_spring_boot() {
    local START_DIR=$(pwd)

    local java_version_from_initializr_config=$(get_java_version_from_initializr_config)

    # 1. Check if Java and Git are installed
    log_major_step "Checking prerequisites..."
    assert_spring_boot_prerequisites $java_version_from_initializr_config
    log_major_step "Prerequisites met! Begin project setup."

    # 2. Prompt for project name
    prompt_project_name PROJECT_DIR

    # 3. Configure SSH directory
    configure_ssh SSH_DIR

    # 4. Configure Git remote repository (optional)
    prompt_git_remote GIT_REMOTE_URL

    # 5. Select all cp libraries you want to include
    prompt_cp_libraries "SPRING" LIBRARIES_CHOICE
    LIBRARIES_NAMES=$(library_numbers_to_names "$LIBRARIES_CHOICE" "BE")

    # 6. Prompt for including Open API generator plugin
    prompt_boolean "Would you like to include Open API generator?" INCLUDE_API
    
    log_major_step "Using configuration:"
    log "Project name: $PROJECT_DIR"
    log "SSH directory: $SSH_DIR"
    log "Git remote URL: $GIT_REMOTE_URL"
    log "Libraries: $LIBRARIES_NAMES"
    log "Include api: $INCLUDE_API"

    log_major_step "Generating Spring Boot project..."

    # 7. Download cp-spring-initializr jar file
    log "Downloading 'CP-Spring-Initializr'..."

    # '-f' argument returns a non-zero exit code on HTTP error response
    # '-L' argument sets the link to download from
    # '-o' argument renames the downloaded file
    curl -f -L "$SPRING_INITIALIZR_JAR_URL" -o "$LOCAL_JAR_NAME"
    curl_status=$?

    # 8. Initialize project generation if the jar file was downloaded successfully
    if [ $curl_status -eq 0 ]; then
        log "Initializing project generation..."
        # Execute the jar file
        java -jar $LOCAL_JAR_NAME --name=$PROJECT_DIR --includeApi=$INCLUDE_API --dependencies=$LIBRARIES_NAMES --verbose=$verbose
        java_status=$?
    else
        log_error "'CP-Spring-Initializr' could not be downloaded!"
        # Exit if downloading the jar file failed
        exit 1
    fi

    # 9. Delete the jar file if it executed successfully
    if [ $java_status -eq 0 ]; then
        log "Successfully generated project '$PROJECT_DIR'."
    else
        log_error "'CP-Spring-Initializr' could not be executed!"
    fi

    # 10. Delete the downloaded jar file
    rm -f cp-spring-initializr.jar
}


get_java_version_from_initializr_config() {
    local java_version_from_initializr_config=$(curl -sSfL "$RAW_SPRING_INITIALIZR_CONFIG" | grep -A 2 "javaVersions:" | grep "id:" | awk -F: '{print $2}' | tr -d ' ')
    echo $java_version_from_initializr_config
}