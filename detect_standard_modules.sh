#!/usr/bin/bash

#Check if both required parameters [PATH] and [VERSION] exist first
if [ -n "$1" ]  &&  [ -n "$2" ]; then

    case "$2" in
        17.0)
            echo "NOTE: This will compare to Odoo 17.0 Enterprise Edition's modules"
            mapfile -t STANDARD_MODULES < modules_17.0.txt  #Read from the standard 18.0 modules text file
        ;;
        18.0)
            echo "NOTE: This will compare to Odoo 18.0 Enterprise Edition's modules"
            mapfile -t STANDARD_MODULES < modules_18.0.txt  #Read from the standard 18.0 modules text file
        ;;
        *)
            echo "Invaild [VERSION] specified. Options: 17.0, 18.0" #Unimplemented versions or invalid parameter [VERSION] goes here.
            exit 1
        ;;
    esac
    
    #Get the number of lines/modules that exist in the standard modules' list
    standard_count=${#STANDARD_MODULES[@]}

    count=0 #Start a counter that will be used in the nested loop. The nested loop first uses EACH actual module (in the [PATH]) and compares it
    #to ALL standard modules. If a module is standard, a match will be found, and the counter won't be equal the standard modules' count.
    #If the count is equals to the standard modules' count, that means the script failed to find a match that number of times, therefore the module is custom

    modules=$(ls "$1")
    for module in $modules; do
        for standard_module in "${STANDARD_MODULES[@]}"; do
            if [  "$module" != "$standard_module" ]; then
                count=$((count+1))
            else
                break
            fi
        done

        if [[ "$count" == "$standard_count" ]]; then
            echo "Found: $module"
        fi
        count=0
    done

else
    echo "To use this script, specify the parameters: $0 [PATH] [VERSION]"
fi

