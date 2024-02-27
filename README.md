# Booty v0.0.16

## Description
Booty is a command-line interface tool designed for Cleverpine employees, simplifying the process of setting up and configuring projects in alignment with the latest technological standards and company-specific libraries.

Booty enables the setup of various project types, including:

Entire Projects: Integrating front-end, back-end, and QA automation services.
Back-end Services: Tailored for technologies like Spring Boot and Quarkus.
Front-end Services: Facilitating creation using Angular, React, and other front-end technologies.
QA Automation Services: Establishing projects with necessary frameworks for Quality Assurance and automated testing.

## Installation
To install Booty, use Homebrew:

```
brew tap cleverpine/booty
brew install booty
```

## Configuration
No additional configuration is needed after installation.

## Usage
Start the Booty CLI with:

```
booty
```

Enabling Verbose Mode
Verbose mode provides detailed output during the setup process. To enable it, start Booty with the -v flag:

```
booty -v/--verbose
```


### Project Setup
Follow the intuitive UI in the Booty CLI to select and configure your project.

### Library Reference
Refer to angular-libraries.sh, spring-libraries.sh, and quarkus-libraries.sh in the booty-configurations folder for a list of available libraries to include in your project setup.

### Exiting Booty
Exit the CLI at any time by typing exit.


### Example of use when setting up a Spring Boot project

```
Please select the type of backend you want to set up:
1. Spring Boot
2. Quarkus

Enter the number of your choice (or type 'help' for more options): 2

----------------------------------------------------------------------------------------------------------------------------
Checking prerequisites...
----------------------------------------------------------------------------------------------------------------------------

[VERBOSE] Checking for Java...
[VERBOSE] Checking for Git...
[VERBOSE] Java version 17 is compatible with the required to work with a Quarkus project.

Java version: openjdk 17 2021-09-14 OpenJDK Runtime Environment (build 17+35-2724) OpenJDK 64-Bit Server VM (build 17+35-2724, mixed mode, sharing)
Git version: git version 2.33.0

----------------------------------------------------------------------------------------------------------------------------
Prerequisites met! Begin project setup.
----------------------------------------------------------------------------------------------------------------------------


Enter name for your  project:  new-quarkus-project
[VERBOSE] Using project name: new-quarkus-project...

Enter a specific SSH directory (leave blank for default):  
[VERBOSE] Using default SSH directory /Users/ivannikolov/.ssh/id_rsa...

Paste a clone URL (leave blank if none):  

----------------------------------------------------------------------------------------------------------------------------
Choose additional libraries to install
----------------------------------------------------------------------------------------------------------------------------

0. none
1. cp-spring-jpa-specification-resolver
2. cp-spring-error-util
3. cp-virava-spring-helper
4. cp-jpa-specification-resolver
5. cp-logging-library

Type 'help' to see more detailed description for each library.

Enter a comma-separated list of libraries you wish to include (leave blank for all):  
```