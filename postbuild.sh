#!/usr/bin/env bash
# tsc;
#  find *.d.ts -type f  ! -name 'index.d.ts' -delete;

# Move our image files and retain file/directory names
rsync -a --exclude=*.{ts,js,tsx,zip,txt,bak} ./src/* ./lib;

# Traverse the directories of our original files and replace the optimized ones with their originals
function traverse() {   
    for file in $(ls "$1")
    do
        if [[ ! -d ${1}/${file} ]]; then
            # Is file
            # Check if the file is of extension .bak AND if it was originally an SVG file
            if [[ ${1}/${file} == *.bak ]] && [[ ${1}/${file%.bak*} == *.svg ]]; then
                # If above is true, delete the optimized version and restore the .bak file
                rm ${1}/${file%.bak*};
                mv ${1}/${file} ${1}/${file%.bak*};
            fi;
        else
            # Is directory
            traverse "${1}/${file}"
        fi
    done
}
function main() {
    traverse "$1";
}
main "./src";
