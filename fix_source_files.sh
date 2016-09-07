#!/bin/bash

# Directories
source_dir="docker-scripts"

# Sanitize data in source files
echo "Generalizing 'character varying(##)' data types to 'text'..."

for file in ${source_dir}/*; do
    sed -i 's/CHARACTER VARYING([0-9]*)/TEXT/Ig' ${file}
done

echo

echo "Done."