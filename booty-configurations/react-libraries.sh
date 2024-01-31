# React libraries

readonly MATERIAL_UI="@mui/material:5.15.6"
readonly EMOTION_REACT="@emotion/react:11.11.3"
readonly EMOTION_STYLED="@emotion/styled:11.11.0"

readonly react_libraries=(
    "1:${MATERIAL_UI}"
    "2:${EMOTION_REACT}"
    "3:${EMOTION_STYLED}"
)

# Rreact libraries descriptions
readonly react_libs_descriptions=(
    #1
    "Material UI is an open-source React component library that implements Google's Material Design.
     It's comprehensive and can be used in production out of the box.\n
     Docs: \033[4mhttps://github.com/mui/material-ui\033[0m"
     #2
     "Simple styling in React.
     Docs: \033[4mhttps://github.com/emotion-js\033[0m"
     #3
     "The styled API for @emotion/react.
     Docs: \033[4mhttps://github.com/emotion-js\033[0m"

)