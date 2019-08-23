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


FROM node:10.16

# protoc-gen-ts
RUN npm install -g grpc_tools_node_protoc_ts@2.5.4 grpc-tools@1.8.0 --unsafe-perm

RUN ln -s /usr/local/lib/node_modules/grpc_tools_node_protoc_ts/bin /grpc_tools_node_protoc_ts

ENV PROTOC_GEN_TS_PATH /grpc_tools_node_protoc_ts/protoc-gen-ts
ENV GRPC_TOOLS_NODE_PROTOC_PLUGIN_PATH /grpc_tools_node_protoc_ts/grpc_tools_node_protoc_plugin

# protoc-gen-grpc-web
RUN curl -L https://github.com/grpc/grpc-web/releases/download/1.0.6/protoc-gen-grpc-web-1.0.6-linux-x86_64 --output /usr/local/bin/protoc-gen-grpc-web
RUN chmod +x /usr/local/bin/protoc-gen-grpc-web

COPY --from=protoc_builder /out/ /