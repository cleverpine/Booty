# Quarkus libraries
readonly quarkus_libraries=(
    #CP related
    "1:cp-spring-jpa-specification-resolver:2.2.4"
    "2:cp-spring-error-util:2.0.1"
    "3:cp-virava-spring-helper:3.1.3"
    "4:cp-jpa-specification-resolver:1.0.0"
    "5:cp-logging-library:1.0.9"
)

# Backend libraries descriptions
readonly quarkus_libraries_descriptions=(
    #1
    "The filtering of resources by various dynamic and complex criteria is an essential part in many RESTful APIs.\n 
    Unfortunately, there is no established standard for sending the filtering arguments to a RESTful API, on another\n 
    hand, the filtering database queries are unique for each scenario, which requires some configurations.\n
    Docs: \033[4mhttps://github.com/cleverpine/cp-spring-jpa-specification-resolver\033[0m"
    #2
    "TO BE ADDED\n
    Docs: \033[4mhttps://github.com/cleverpine/cp-spring-error-util\033[0m"
    #3
    "TO BE ADDED\n
    Docs: \033[4mhttps://github.com/cleverpine/cp-virava-spring-helper\033[0m"
    #4
    "The filtering of resources by various dynamic and complex criteria is an essential part in many RESTful APIs.\n 
    Unfortunately, there is no established standard for sending the filtering arguments to a RESTful API, on another\n 
    hand, the filtering database queries are unique for each scenario, which requires some configurations.\n
    Docs: \033[4mhttps://github.com/cleverpine/cp-jpa-specification-resolver\033[0m"
    #5
    "CleverPine logging library is a lightweight and efficient solution that can easily be integrated into various Java\n
     applications. It utilizes Log4j2 as its underlying logger, providing robust and customizable logging capabilities.\n
     With this library, developers can quickly and easily add logging functionality to their applications, allowing them to\n
     track events, troubleshoot issues, and gather valuable insights into their software's performance.\n
    Docs: \033[4mhttps://github.com/cleverpine/cp-logging-library\033[0m"
)