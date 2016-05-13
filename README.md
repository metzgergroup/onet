# Re-create the ONET database

This repo offers 2 methods of creating the ONET database:
1. for Docker containers
2. for local Postgres installations

For either method, the first steps are to clone this repo:

    git clone https://github.com/bfin/onet.git

download [the source files](https://www.onetcenter.org/database.html) in MySQL format, and unzip into the `source` directory.

---

## Docker Postgres

We have 3 options for running the database under Docker:
1. Re-create the database from source files
2. Run a container with the data "baked in"
3. Run a container with the data in an attached data volume

### Option 1: Re-create from source files

We can re-create the database from the SQL source files by mounting the source directory in the `/docker-entrypoint-initdb.d` directory of the stock Postgres container:

    docker run \
        --name onet \
        --volume $(pwd)/source:/docker-entrypoint-initdb.d \
        -e "POSTGRES_DB=onet" \
        postgres:9.5

This is the only way to create the database from scratch, but it takes a long time and writes the data to a directory that is mounted as a volume (i.e., it won't persist).

### Option 2: Bake it in

We can improve on the first option by instructing the container to write the data to a directory that isn't exposed as a volume. We can then commit the modified container as a new iamge that has the data baked in.

Run a new Postgres container to create the database, specifying a directory other than `/var/lib/postgresql/data` as the `PGDATA` environment variable:

    docker run \
        --name onet \
        --volume $(pwd)/source:/docker-entrypoint-initdb.d \
        -e "POSTGRES_DB=onet" \
        -e "PGDATA=/var/lib/postgresql/static-data" \
        postgres:9.5

Commit the container's file changes into a new image:

    docker commit onet bfin/onet

Login to Docker Hub (if necessary):

    docker login

Push the container image to registry:

    docker push bfin/onet

### Option 3: Use a data volume

This option more closely follows the community best practices by isolating the application container from the data.

Create a data volume in which to store the database files

    docker volume create --name onet_data

Run a new Postgres container to create the database, attaching the data volume to the `PGDATA` directory:

    docker run \
        --rm \
        --name onet \
        --volume $(pwd)/source:/docker-entrypoint-initdb.d \
        --volume onet_data:/var/lib/postgresql/data \
        -e "POSTGRES_DB=onet" \
        postgres:9.5

The database files are now located in the data volume we created earlier. Run another container with that data volume attached and create a tar archive of it in yet another volume:

    docker run \
        --rm \
        --volume onet_data:/data \
        --volume $(pwd)/backup:/backup \
        busybox \
        tar -cvzf /backup/onet_data.tar.gz /data

Our archive of the Postgres data is now in the `backup` directory. If we were to download it on another system (without the data volume from which we created the archive), to use it we would first have to create a new data volume:

    docker volume create --name onet_data

Then extract the archive into the data volume:

    docker run \
        --rm \
        --volume onet_data:/data \
        --volume $(pwd)/backup:/backup \
        busybox \
        tar -zxvf /backup/onet_data.tar.gz -C /data

Finally, run the Postgres container with the data volume attached:

    docker run \
        --name onet \
        --volume onet_data:/var/lib/postgresql/data \
        -e "POSTGRES_DB=onet" \
        postgres:9.5

---

## Local Postgres

### Create local database

Executing the `create_database.sh` script will execute all `.sql` files in the `source` directory to create the database locally (named `onet` by default) and then backup the database to a file (named `onet.dump` by default).

    sh create_database.sh

### Create online database (optional)

If you already have an online database named `onet`:

    psql --host <endpoint> --port <port> --username <user> --dbname onet

If no online database exists yet but you have a server instance running, connect to the `template1` database:

    psql --host <endpoint> --port <port> --username <user> --dbname template1

Then create the `onet` database from within `psql`:

    CREATE DATABASE onet;

### Copy to online database

    pg_restore --host <endpoint> --port <port> --username <user> --dbname onet --schema public --no-owner --no-privileges --no-tablespaces --verbose onet.dump

---

### Notes

Download the accompanying O*NET Data Dictionary to identify if any file structure changes have taken place between database releases.
