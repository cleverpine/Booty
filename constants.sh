readonly BOOTY_CONFIGS_REPO_URL="https://github.com/cleverpine/pineboot-configurations.git"
readonly RAW_ANGULAR_SKELETON_PACKAGE_JSON="https://raw.githubusercontent.com/cleverpine/angular-skeleton/main/package.json"
readonly SSH_ANGULAR_SKELETON_CLONE_URL="git@github.com:cleverpine/angular-skeleton.git"


# Compatibility versions according to Angular's documentation
readonly angular_versions=("17.0.x" "16.1 || 16.2.x" "16.0.x" "15.1.x || 15.2.x" "15.0.x")
readonly node_versions=("^18.13.0 || ^20.9.0" "^16.14.0 || ^18.10.0" "^16.14.0 || ^18.10.0" "^14.20.0 || ^16.13.0 || ^18.10.0" "^14.20.0 || ^16.13.0 || ^18.10.0")

# Backend libraries
readonly backend_libraries=(
    "1:cp-spring-jpa-specification-resolver"
    "2:cp-spring-error-util"
    "3:cp-virava-spring-helper"
    "4:cp-jpa-specification-resolver"
    "5:cp-logging-library"
)

# Frontend libraries
readonly frontend_libraries=(
    "1:cp-lht-header:0.0.6"
    "2:cp-lht-sidebar:0.0.8"
    "3:cp-lht-tile:0.0.6"
    "4:primeng:17.1.0"
    "5:syncfusion:latest" #???? 
    "6:ng-openapi-gen:0.51.0"
)


# Color codes used for logging
export RED='\033[31m'
export GREEN='\033[32m'
export PURPLE='\033[35m'
export YELLOW='\033[33m'
export BOLD='\033[1m'
export NC='\033[0m' # No Color