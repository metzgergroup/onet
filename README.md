## Re-create the ONET database

### 1. Install required binaries

- `zsh`

    ```
    brew install zsh
    ```

### 2. Clone repo

    git clone https://github.com/bfin/onet.git

### 3. Download [source files](https://www.onetcenter.org/database.html) in MySQL format and unzip into `source` directory

### 4. Create local database

Executing the `create_database.zsh` script will execute all `.sql` files in the `source` directory to create the database locally (named `onet` by default) and then backup the database to a file (named `onet.dump` by default).

    zsh create_database.zsh

### 5. Create online database

If you already have an online database named `onet`:

    psql --host=<endpoint> --port=<port> --username=<user> --dbname=onet

If no online database exists yet but you have a server instance running, connect to the `template1` database:

    psql --host=<endpoint> --port=<port> --username=<user> --dbname=template1

Then create the `onet` database from within `psql`:

    CREATE DATABASE onet;

### 6. Copy to online database

    pg_restore --host=<endpoint> --port=<port> --username=<user> --dbname=onet --schema=public --no-owner --no-privileges --no-tablespaces --verbose onet.dump

### Changes

Download the accompanying O*NET Data Dictionary to identify if any file structure changes have taken place between database releases.