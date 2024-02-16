# Backend libraries
readonly spring_libraries=(
    "1:cp-spring-error-util"
    "2:cp-virava-spring-helper"
    "3:cp-jpa-specification-resolver"
    "4:cp-logging-library"
)

# Backend libraries descriptions
readonly spring_libs_descriptions=(
    #1
    "CleverPine spring error util library provides global expcetion handling & reusable error response model\n
    Docs: \033[4mhttps://github.com/cleverpine/cp-spring-error-util\033[0m"
    #2
    "TO BE ADDED\n
    Docs: \033[4mhttps://github.com/cleverpine/cp-virava-spring-helper\033[0m"
    #3
    "The filtering of resources by various dynamic and complex criteria is an essential part in many RESTful APIs.\n 
    Unfortunately, there is no established standard for sending the filtering arguments to a RESTful API, on another\n 
    hand, the filtering database queries are unique for each scenario, which requires some configurations.\n
    Docs: \033[4mhttps://github.com/cleverpine/cp-jpa-specification-resolver\033[0m"
    #4
    "CleverPine logging library is a lightweight and efficient solution that can easily be integrated into various Java\n
     applications. It utilizes Log4j2 as its underlying logger, providing robust and customizable logging capabilities.\n
     With this library, developers can quickly and easily add logging functionality to their applications, allowing them to\n
     track events, troubleshoot issues, and gather valuable insights into their software's performance.\n
    Docs: \033[4mhttps://github.com/cleverpine/cp-logging-library\033[0m"
)