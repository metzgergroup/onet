# ONET Database

This repo provides instructions to re-create the ONET database in a Docker image available at registry.gitlab.com/metzger-group/onet<tag>.

The image is built, tagged, and pushed to the registry via a GitLab CI pipeline. In that pipeline, the database is created from the source data with the database files written into a Docker volume, then that volume is used to overwrite the default `PGDATA` directory in a new Postgres image. Source files are stored using the git large file service.

#### Note for future versions

When a new database is released, download [the zipped source files](https://www.onetcenter.org/database.html) (in the MySQL format) into the `docker-scripts` directory and review the data structure for changes/errors. The source files for ONET 21.0 included an error: the table schema in `35_alternate_titles.sql` specifies type `character varying(150)` for the `alternate_title` column, but at least 1 of the alternate titles exceeds 150 characters. We can correct this error by changing `character varying(150)` to `text`, as is done in the CI pipeline with the `fix_source_files.sh` script. Expect errors and/or structural changes in subsequent datasets as well. Downloading the accompanying O*NET Data Dictionary can help to identify if any file structure changes have taken place between database releases.

#### Note for local development

The `fix_source_script.sh` script requires the GNU version of `sed`, which can be installed on Mac OS X using Homebrew:

    brew install gnu-sed --with-default-names
