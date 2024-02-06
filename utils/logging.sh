SEPARATOR=$(printf '%*s\n' "$(tput cols)" '' | tr ' ' -)

log_bolded() {
      echo -e "${BOLD}$1${NC}"    
}

log() {
    echo -e $1
}

log_error() {
    echo -e "${BOLD}${RED}$1${NC}"
}

log_warning() {
    log "${YELLOW}$1${NC}"
}

log_verbose() {
    if [ "$verbose" = true ]; then
        log "[VERBOSE] $1"
    fi
}

log_major_step() {
    log ""
    log $SEPARATOR
    log "${PURPLE}$1${NC}"
    log $SEPARATOR
    log ""
}