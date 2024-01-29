# Frontend libraries

readonly CP_LHT_HEADER="cp-lht-header:0.0.6"
readonly CP_LHT_SIDEBAR="cp-lht-sidebar:0.0.8"
readonly CP_LHT_TILE="cp-lht-tile:0.0.6"
readonly PRIME_NG="primeng:17.1.0"
readonly SYNC_FUSION="syncfusion:latest"
readonly CP_OPENAPI_GEN_PLUGIN="cp-openapi-gen-plugin:0.0.6"



readonly frontend_libraries=(
    "1:${CP_LHT_HEADER}"
    "2:${CP_LHT_SIDEBAR}"
    "3:${CP_LHT_TILE}"
    "4:${PRIME_NG}"
    "5:${SYNC_FUSION}" #???? 
    "6:${CP_OPENAPI_GEN_PLUGIN}"
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
    "Syncfusion provides the best third-party UI components for Blazor, .NET MAUI, Flutter, Xamarin, Angular, JavaScript, React, Vue, WinForms, WPF and WinUI\n
    Docs: \033[4mhttps://github.com/syncfusion\033[0m"
    #6
    "This project is a NPM module that generates model interfaces and web service clients from an OpenApi 3 specification.\n 
    The generated classes follow the principles of Angular. The generated code is compatible with Angular 12+.\n
    Docs: \033[4mhttps://github.com/cyclosproject/ng-openapi-gen\033[0m"
)