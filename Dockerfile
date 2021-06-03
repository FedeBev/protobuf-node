ARG UBUNTU_VERSION
ARG NODE_VERSION

FROM ubuntu:${UBUNTU_VERSION} as protoc_builder

ARG PROTOC_VERSION
ARG GRPC_WEB_VERSION
RUN apt-get update && apt-get install -y curl unzip && mkdir /protoc && \
    curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip && \
    unzip protoc-${PROTOC_VERSION}-linux-x86_64.zip -d /protoc && \
    curl -LO https://github.com/grpc/grpc-web/releases/download/${GRPC_WEB_VERSION}/protoc-gen-grpc-web-${GRPC_WEB_VERSION}-linux-x86_64 && mv protoc-gen-grpc-web-${GRPC_WEB_VERSION}-linux-x86_64 /protoc-gen-grpc-web


FROM node:${NODE_VERSION}-slim


ARG TS_PROTOC_GEN_VERSION
ARG GRPC_TOOLS_VERSION
LABEL maintainer="Federico Bevione <bevione.federico95@gmail.com>"
RUN npm config set unsafe-perm true && npm install -g ts-protoc-gen@${TS_PROTOC_GEN_VERSION} grpc-tools@${GRPC_TOOLS_VERSION} && npm cache clean --force

COPY --from=protoc_builder /protoc/bin/ /usr/local/bin
COPY --from=protoc_builder /protoc/include/ /usr/local/include
COPY --from=protoc_builder /protoc-gen-grpc-web /usr/local/bin/protoc-gen-grpc-web

RUN chmod +x /usr/local/bin/protoc-gen-grpc-web && \
    ln -s /usr/local/lib/node_modules/ts-protoc-gen/bin/protoc-gen-ts /usr/bin/protoc-gen-ts && \
    ln -s /usr/local/bin/grpc_tools_node_protoc_plugin /usr/bin/protoc-gen-grpc

ENV LD_LIBRARY_PATH='/usr/lib:/usr/lib64:/usr/lib/local'

ENTRYPOINT ["protoc", "-I/usr/include"]