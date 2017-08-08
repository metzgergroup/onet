#!/bin/bash

# Directories
source_dir="docker-scripts"

echo "Changing to unlogged tables for faster inserts and generalizing 'character varying(##)' data types to 'text'..."

for file in ${source_dir}/*; do
    sed -i 's/CREATE TABLE/CREATE UNLOGGED TABLE/Ig' ${file}
    sed -rn 's/CREATE UNLOGGED TABLE ([a-z_]+) \(/ALTER TABLE \1 SET LOGGED;/Igp' ${file} | tee -a ${file}
    sed -i 's/CHARACTER VARYING([0-9]*)/TEXT/Ig' ${file}
done

echo

echo "Done."
