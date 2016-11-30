FROM postgres:9.6.1-alpine

ADD ./backup/data.tar.gz $PGDATA