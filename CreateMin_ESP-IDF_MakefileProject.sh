#!/bin/bash
#
# A script to create minimum makefile esp-idf project.
# by: vpangaldus
#

project_name=

function help {
  echo 
  echo -e >&2 "Usage: $0 -n <project_name>"
  echo -e >&2 "Create minimum makefile esp-idf project with vscode as editor."
  echo -e >&2 "\nwhere:\n\t<project_name>          : the name of the project."
  echo 
  echo -e >&2 "example: $0 -n hello_world"
}

# handle command line argument
while [ $# -gt 0 ]
do
    case "$1" in
        -n) project_name="$2"; shift;;
        -d) project_location="$2"; shift;;
        -*)
            help
            exit 1;;
        *)
            break;;       
    esac
    shift
done

# Check inp args
if [ -z "$project_name" ]; then
  echo -e ">>> Error: please supply all the required arguments"
  help
  exit 1
fi

# Create project dir and go to the dir
mkdir -p $project_name
cd $project_name

# Create makefile
touch Makefile
cat > Makefile << EOL
PROJECT_NAME := $project_name

include \$(IDF_PATH)/make/project.mk

EOL

# Create main dir and its content
mkdir main
touch main/main.c
touch main/component.mk

cat > main/main.c << EOL
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

void app_main()
{

}

EOL

# Create vscode config
mkdir .vscode
touch .vscode/c_cpp_properties.json
touch .vscode/tasks.json

cat > .vscode/c_cpp_properties.json << EOL
{
    "configurations": [
        {
            "name": "Linux",
            "includePath": [
                "\${workspaceFolder}/**",
                "\${env:XTENSA_TOOLCHAIN_PATH}/lib/gcc/xtensa-esp32-elf/5.2.0/include/**",
                "\${env:XTENSA_TOOLCHAIN_PATH}/lib/gcc/xtensa-esp32-elf/5.2.0/include-fixed/**",
                "\${env:XTENSA_TOOLCHAIN_PATH}/xtensa-esp32-elf/include/**",
                "\${env:XTENSA_TOOLCHAIN_PATH}/xtensa-esp32-elf/sysroot/usr/include/**",
                "\${env:IDF_PATH}/components/**"
            ],
            "browse": {
                "path": [
                    "\${workspaceRoot}",
                    "\${env:XTENSA_TOOLCHAIN_PATH}/lib/gcc/xtensa-esp32-elf/5.2.0/include/**",
                    "\${env:XTENSA_TOOLCHAIN_PATH}/lib/gcc/xtensa-esp32-elf/5.2.0/include-fixed/**",
                    "\${env:XTENSA_TOOLCHAIN_PATH}/xtensa-esp32-elf/include/**",
                    "\${env:XTENSA_TOOLCHAIN_PATH}/xtensa-esp32-elf/sysroot/usr/include/**",
                    "\${env:IDF_PATH}/components/**"
                ],
                "limitSymbolsToIncludedHeaders": true,
                "databaseFilename": ""
            },
            "intelliSenseMode": "clang-x64",
            "defines": [],
            "cStandard": "c11",
            "cppStandard": "c++14"
        }
    ],
    "version": 4
}
EOL

cat > .vscode/tasks.json << EOL
{
    // See https://go.microsoft.com/fwlink/?LinkId=733558
    // for the documentation about the tasks.json format

    // The tasks here is based on the output of make help

    "version" : "2.0.0",

    "tasks": [

        // make all - Build app, bootloader, partition table
        {
            "label": "all",
            "type": "shell",
            "command": "make all -j 2",
            "group": {
                "kind": "build",
                "isDefault": true
            }
        },

        // make clean - Remove all build output
        {
            "label": "clean",
            "type": "shell",
            "command": "make clean"
        },

        // make app - Build just the app
        {
            "label": "app",
            "type": "shell",
            "command": "make app -j 2"
        },

        // make app-clean - Clean just the app
        {
            "label": "app-clean",
            "type": "shell",
            "command": "make app-clean"
        },

        // make size - Display the static memory footprint of the app
        {
            "label": "size",
            "type": "shell",
            "command": "make size"
        }

    ]
}
EOL

# EOF
