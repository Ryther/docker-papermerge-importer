FROM ghcr.io/linuxserver/baseimage-alpine:3.13
LABEL org.opencontainers.image.source=https://github.com/ryther/docker-papermerge-importer

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
            $BUILD_PACKAGES
RUN git clone https://github.com/Ryther/papermerge-importer.git /app/papermerge-importer && \
    rm -rf /app/papermerge-importer/.git
RUN apk add --no-cache \
            --virtual=runtime-dependencies \
            $RUNTIME_PACKAGES
RUN echo "**** cleanup ****" && \
    rm -rf \
	    /root/.cache \
	    /tmp/* && \
    apk del build-dependencies

COPY root/ /

ENV WATCH_FOLDER=/data/papermerge/import

HEALTHCHECK --interval=10s --start-period=10s --retries=3 CMD /bin/sh /app/papermerge-importer/healthcheck.sh
ENTRYPOINT ["/init"]
