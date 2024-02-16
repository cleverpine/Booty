# Quarkus libraries

readonly CP_JPA_SPECIFICATION_RESOLVER="cp-jpa-specification-resolver"
readonly CP_JPA_SPECIFICATION_RESOLVER_VERSION="1.0.0"

readonly quarkus_libraries=(
    #CP related
    "1:${CP_JPA_SPECIFICATION_RESOLVER}:${CP_JPA_SPECIFICATION_RESOLVER_VERSION}"
)

# Backend libraries descriptions
readonly quarkus_libs_descriptions=(
    #1
    "The filtering of resources by various dynamic and complex criteria is an essential part in many RESTful APIs.\n 
    Unfortunately, there is no established standard for sending the filtering arguments to a RESTful API, on another\n 
    hand, the filtering database queries are unique for each scenario, which requires some configurations.\n
    Docs: \033[4mhttps://github.com/cleverpine/cp-jpa-specification-resolver\033[0m"
)