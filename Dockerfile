FROM postgres:9.5.4

ADD ./backup/data.tar.gz $PGDATA