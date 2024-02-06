# Frontend libraries

readonly CP_LHT_HEADER="cp-lht-header"
readonly CP_LHT_HEADER_VERSION="0.0.6"

readonly CP_LHT_SIDEBAR="cp-lht-sidebar"
readonly CP_LHT_SIDEBAR_VERSION="0.0.8"

readonly CP_LHT_TILE="cp-lht-tile"
readonly CP_LHT_TILE_VERSION="0.0.6"

readonly PRIME_NG="primeng"
readonly PRIME_NG_VERSION="17.1.0"

readonly CP_OPENAPI_GEN_PLUGIN="cp-openapi-gen-plugin"
readonly CP_OPENAPI_GEN_PLUGIN_VERSION="0.0.6"


# NOTE - Consider using a @ instead of : to resolve all further problems when comparing in the code
readonly frontend_libraries=(
    "1:${CP_LHT_HEADER}:${CP_LHT_HEADER_VERSION}"
    "2:${CP_LHT_SIDEBAR}:${CP_LHT_SIDEBAR_VERSION}"
    "3:${CP_LHT_TILE}:${CP_LHT_TILE_VERSION}"
    "4:${PRIME_NG}:${PRIME_NG_VERSION}"
    "5:${CP_OPENAPI_GEN_PLUGIN}:${CP_OPENAPI_GEN_PLUGIN_VERSION}"
)

# Frontend libraries descriptions
readonly frontend_libs_descriptions=(
    #1
    "The Sidebar Component provides a component that can be used to create a sidebar.\n
     Docs: \033[4mhttps://github.com/cleverpine/cp-angular-header\033[0m"
    #2
    "The Sidebar Component provides a component that can be used to create a sidebar.\n
     Docs: \033[4mhttps://github.com/cleverpine/cp-angular-sidebar\033[0m"
    #3
    "The Tile Component provides a component that can be used to create a tile with hover effect.\n
    Docs: \033[4mhttps://github.com/cleverpine/cp-angular-tile\033[0m"
    #4
    "Advertised as the most complete UI Library for Angular.\n
    Docs: \033[4mhttps://github.com/primefaces/primeng\033[0m"
    #5
    "This project is a NPM module that generates model interfaces and web service clients from an OpenApi 3 specification.\n 
    The generated classes follow the principles of Angular. The generated code is compatible with Angular 12+.\n
    Docs: \033[4mhttps://github.com/cyclosproject/ng-openapi-gen\033[0m"
)