#! /bin/bash

# Directories
source_dir="source"

# New database name
dbname='onet'

# Create empty database
echo "Creating database named ${dbname}..."
createdb ${dbname}
echo "Database created."

# Execute SQL commands from files to build database
for file in ${source_dir}/*.sql; do
    echo "Executing ${file}..."
    psql --file ${file} --quiet --dbname ${dbname}
done

# Create backup
echo "Backing up to ${dbname}.dump..."
pg_dump --no-owner --format custom --compress 9 ${dbname} > ${dbname}.dump
echo "Backup complete."

echo "Done."
