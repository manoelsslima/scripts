#!/bin/bash

function scan_directories() {

    local file_extension="$1"
    local source_encoding="$2"
    local target_encoding="$3"
    local source_directory="$4"

    backup_prefix="_bkp"

    log_file="log.log"
    # echo "Changed files:" >> $log_file ; chmod 777 log_file

    for dir in ${source_directory}/*; do
        if [ -f "$dir" ]; then                                            # if it's a file
            file_extension_actual=$(echo $dir | cut -d"." -f2)            # file extension
            if [ "$file_extension_actual" == ${file_extension} ]; then
                backup_file_name=${dir}${backup_prefix}

                # convert encoding
                iconv -f ${source_encoding} -t ${target_encoding} $dir > $backup_file_name

                mv $backup_file_name $dir
                echo "${dir}" >> ${source_directory}/${log_file}           # log
            fi
        fi
        if [ -d "$dir" ]; then                                            # if it's a directory
            cd "$dir"                                                     # enter the directory
            scan_directories "$dir"                                       # do recursion
        fi
        cd ..
    done
}


echo "=================================================="
echo "File encoding converter"
echo "Author: Manoel Lima <manoelsslima@yahoo.com.br>"
echo "=================================================="
echo ""
echo "Usage: ./encoding-converter.sh <file_extension> <source_encoding> <target_encoding> <source_file_path>"
echo ""
echo ""

scan_directories $1 $2 $3 $4
