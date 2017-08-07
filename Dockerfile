FROM postgres:9.6.3-alpine

ADD ./backup/data.tar.gz $PGDATA
