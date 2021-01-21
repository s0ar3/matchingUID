#!/usr/bin/bash

declare -a elements
usage="$0 [-k KEY (UID)] [-v (USER)] input"
declare -a input_keysOrValues=("$@")

pupulateUIDandVALUES() {
    for i in $(awk 'BEGIN {FS=":"} {print $1":"$3}' /etc/passwd) ; do
       elements[${i#*:}]=${i%:*}
    done
}

getValueAndKeys() {
    local given_input="${1}"
    for ((j=1;j<${#input_keysOrValues[@]};j++)); do
        for i in "${!elements[@]}"; do
            if [[ ${given_input} == "k" ]]; then
                if [[ ${input_keysOrValues[j]} == "${i}" ]]; then  
                    printf "\e[1;32m%s \e[1;34m%s\e[0m \e[1;33m%s\e[0m\n" "${i}" "->" "${elements[i]}"
                fi
            elif [[ ${given_input} == "v" ]]; then
                if [[ ${input_keysOrValues[j]} == "${elements[i]}" ]]; then  
                    printf "\e[1;32m%s\e[0m \e[1;34m%s\e[0m \e[1;33m%s\e[0m\n" "${i}" "->" "${elements[i]}"
                fi
            fi        
        done
    done
}

main() {
    pupulateUIDandVALUES
    while getopts ":kv" option; do
        case "${option}" in
            k) getValueAndKeys "k"
               ;;
            v) getValueAndKeys "v"
               ;;   
            \?) printf "\n\e[31m%s\e[0m\n\n" "ERROR ${usage}"
                exit 1
        esac
    done
}

main "$@"