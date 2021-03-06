SHELL = /bin/bash
IMAGE_NAME = gcr.io/acat-shared/onet
SOURCE_DIR = docker-scripts
PG_VERSION = 11.7
ONET_VERSION = 24_2

.PHONY: download fix clean

download:
	curl \
	    -o ${SOURCE_DIR}/${ONET_VERSION}.zip \
	    https://www.onetcenter.org/dl_files/database/db_${ONET_VERSION}_mysql.zip

	unzip \
	    -j ${SOURCE_DIR}/${ONET_VERSION}.zip \
	    -d ${SOURCE_DIR}

fix:
	@echo "Change to unlogged tables for faster inserts and generalizing 'character varying(##)' data types to 'text'..."
	for file in ${SOURCE_DIR}/*; do \
	    if [[ $$file = *.sql ]]; then \
	        sed -i 's/CREATE TABLE/CREATE UNLOGGED TABLE/Ig' $${file}; \
	        sed -rn 's/CREATE UNLOGGED TABLE ([a-z_]+) \(/ALTER TABLE \1 SET LOGGED;/Igp' $${file} | tee -a $${file}; \
	        sed -i 's/CHARACTER VARYING([0-9]*)/TEXT/Ig' $${file}; \
	    fi; \
	done

build:
	docker build \
	    --build-arg PG_VERSION=$(PG_VERSION) \
	    --tag $(IMAGE_NAME):$(ONET_VERSION) \
	    .

push:
	docker push $(IMAGE_NAME):$(ONET_VERSION)

clean:
	find ${SOURCE_DIR} -type f -not -name "${ONET_VERSION}.zip" -delete
