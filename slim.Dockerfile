FROM ubuntu:18.04 as protoc_builder
RUN apt update && apt install -y curl build-essential apt-utils autoconf libtool

ENV PROTOBUF_VERSION=3.7.0 \
    OUTDIR=/out

# Download protobuf
RUN mkdir -p /protobuf && \
        curl -L https://github.com/google/protobuf/archive/v${PROTOBUF_VERSION}.tar.gz | tar xvz --strip-components=1 -C /protobuf
#compile protobuf
RUN cd /protobuf && \
        autoreconf -f -i -Wall,no-obsolete && \
        ./configure --prefix=/usr --enable-static=no && \
        make -j2 && make install
# install protobuf
RUN cd /protobuf && \
        make install DESTDIR=${OUTDIR}
RUN find ${OUTDIR} -name "*.a" -delete -or -name "*.la" -delete


FROM node:10.15-slim

COPY --from=protoc_builder /out/ /