# ONET Database

This repo provides instructions to re-create the ONET database in a Docker image.

Source files are stored using the git large file service.

#### Note for future versions

When a new database is released, download [the zipped source files](https://www.onetcenter.org/database.html) (in the MySQL format) using `make download` and review the data structure for changes/errors. The source files for ONET 21.0 included an error: the table schema in `35_alternate_titles.sql` specifies type `character varying(150)` for the `alternate_title` column, but at least 1 of the alternate titles exceeds 150 characters. We can correct some generic errors by changing `character varying(150)` to `text`, as is done in `make fix`. Downloading the accompanying O*NET Data Dictionary can help to identify if any file structure changes have taken place between database releases.

#### Note for local development

This requires the GNU version of `sed`, which can be installed on Mac OS X using Homebrew:

    brew install gnu-sed --with-default-names
