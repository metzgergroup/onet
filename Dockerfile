FROM postgres:10.1-alpine

ADD ./backup/data.tar.gz $PGDATA
