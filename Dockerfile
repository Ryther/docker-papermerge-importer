FROM ghcr.io/linuxserver/baseimage-alpine

ARG BUILD_PACKAGES="\
	git"

# packages as variables
ARG RUNTIME_PACKAGES="\
	inotify-tools \
        curl"

RUN mkdir -p \
        /app/papermerge-importer \
        /data/papermerge/import && \
    apk add --no-cache \
            --virtual=build-dependencies \
            $BUILD_PACKAGES && \
    git clone https://github.com/Ryther/papermerge-importer.git /app/papermerge-importer && \
    rm -rf /app/papermerge-importer/.git & \
    apk add --no-cache \
            --virtual=runtime-dependencies \
            $RUNTIME_PACKAGES && \
    echo "**** cleanup ****" && \
    rm -rf \
	    /root/.cache \
	    /tmp/* && \
    apk del build-dependencies

COPY root/ /

ENTRYPOINT ["/init"]
