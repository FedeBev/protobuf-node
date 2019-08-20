FROM ubuntu:18.04 as protoc_builder
RUN apt update && apt install -y curl build-essential apt-utils autoconf libtool

ENV PROTOBUF_VERSION=3.9.1 \
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


FROM node:10.16-slim

ENV PROTOC_GEN_TS_PATH /protoc-gen-ts

# protoc-gen-ts
RUN npm install -g ts-protoc-gen@0.10.0
RUN ln -s /usr/local/lib/node_modules/ts-protoc-gen/bin/protoc-gen-ts /protoc-gen-ts

# protoc-gen-grpc-web
RUN curl -L https://github.com/grpc/grpc-web/releases/download/1.0.6/protoc-gen-grpc-web-1.0.6-linux-x86_64 --output /usr/local/bin/protoc-gen-grpc-web
RUN chmod +x /usr/local/bin/protoc-gen-grpc-web

COPY --from=protoc_builder /out/ /