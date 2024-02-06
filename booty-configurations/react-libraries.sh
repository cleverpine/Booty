# React libraries

readonly MATERIAL_UI="@mui/material"
readonly MATERIAL_UI_VERSION="5.15.6"

readonly EMOTION_REACT="@emotion/react"
readonly EMOTION_REACT_VERSION="11.11.3"

readonly EMOTION_STYLED="@emotion/styled"
readonly EMOTION_STYLED_VERSION="11.11.0"

readonly CP_OPENAPI_GEN_PLUGIN="cp-openapi-gen-plugin"
readonly CP_OPENAPI_GEN_PLUGIN_VERSION="0.0.9"

readonly react_libraries=(
    "1:${MATERIAL_UI}:${MATERIAL_UI_VERSION}"
    "2:${EMOTION_REACT}:${EMOTION_REACT_VERSION}"
    "3:${EMOTION_STYLED}:${EMOTION_STYLED_VERSION}"
    "4:${CP_OPENAPI_GEN_PLUGIN}:${CP_OPENAPI_GEN_PLUGIN_VERSION}"
)

# Rreact libraries descriptions
readonly react_libs_descriptions=(
    #1
    "Material UI is an open-source React component library that implements Google's Material Design.
     It's comprehensive and can be used in production out of the box.\n
     Docs: \033[4mhttps://github.com/mui/material-ui\033[0m"
     #2
     "Simple styling in React. \n
     Docs: \033[4mhttps://github.com/emotion-js\033[0m"
     #3
     "The styled API for @emotion/react. \n
     Docs: \033[4mhttps://github.com/emotion-js\033[0m"
     #4
     "cp-openapi-gen-plugin is a Node.js package designed for automatic generation of models and APIs from an OpenAPI specification. \n
     It leverages the @openapitools/openapi-generator-cli to offer a streamlined, command-line interface for generating \n
     TypeScript Angular or React code from your OpenAPI documents. It also supports a local qa setup for API testing. \n
     Docs: \033[4mhttps://github.com/cleverpine/cp-openapi-gen-plugin\033[0m"
)