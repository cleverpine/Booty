# Booty v0.0.5

Booty CLI Tool
Description
Booty is a command-line interface tool developed for Cleverpine employees to streamline the process of setting up and configuring projects in line with the latest technological standards. It integrates seamlessly with company-developed libraries, ensuring a standardized approach across various project types.

Booty offers the capability to set up diverse types of projects, including:

Entire Projects: Combines front-end, back-end, and QA automation services into a complete project structure.
Back-end Services: Supports technologies like Spring Boot and Quarkus, tailored for robust server-side development.
Front-end Services: Facilitates the creation of front-end services using technologies such as Angular and React.
QA Automation Services: Sets up projects with necessary frameworks for Quality Assurance and automated testing.
Additionally, Booty features a verbose mode, which provides detailed output during the setup process, offering insights into the operations being performed.

Installation
To install Booty, use Homebrew by running the following command:

bash
Copy code
brew tap cleverpine/booty
brew install booty
Configuration
Upon installation, no further configuration is necessary.

Usage
Starting Booty
To initiate the Booty CLI, simply enter the following command in your terminal:

bash
Copy code
booty
Navigation and Selection
Booty's user interface is intuitive, guiding you through various options for setting up your desired project type. Select from the main menu to start configuring your project.

Reference to Available Libraries
Within the booty-configurations folder, you will find files such as angular-libraries.sh, spring-libraries.sh, and quarkus-libraries.sh. These files are crucial references that list the available Cleverpine libraries (and others) that can be included during the project setup process.

Exiting Booty
You can exit the Booty CLI at any point by typing exit.

This revised README.md provides a more detailed overview of the Booty CLI tool, focusing on the types of projects you can set up and including a mention of the verbose mode. The description of the booty-configurations folder and its contents offers a clear reference point for available libraries. If further modifications or additional details are required, feel free to let me know.