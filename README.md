# protobuf-node

## What

Docker image based on node-alpine image with protobuf

## Why

For example for build pipeline of node/typescript project that uses static grpc code generation

## Modules versions

| Modules | Version |
|:-:|:-:|
| node | 14.17.4 |
| protoc | 3.17.3 |
| ts-protoc-gen | 0.15.0 |
| grpc-tools | 1.11.2 |
| grpc-web | 1.2.1 |

## Usage examples

### grpc

Generate files for to be used with [grpc](https://www.npmjs.com/package/grpc)

typescript:

```shell script
docker run --rm \
    -v $(pwd):$(pwd) \
    -w $(pwd) fedebev/protobuf-node:latest \
    -I=${PROTO_PATH} --js_out="import_style=commonjs,binary:${OUT_DIR}" --ts_out="service=grpc-node:${OUT_DIR}" --grpc_out="${OUT_DIR}" ${FILES}
```

node:

```shell script
docker run --rm \
    -v $(pwd):$(pwd) \
    -w $(pwd) fedebev/protobuf-node:latest \
    -I=${PROTO_PATH} --js_out="import_style=commonjs,binary:${OUT_DIR}" --grpc_out="${OUT_DIR}" ${FILES}
```

### grpc-js

Generate files for to be used with [@grpc/grpc-js](https://www.npmjs.com/package/@grpc/grpc-js)

typescript:

```shell script
docker run --rm \
    -v $(pwd):$(pwd) \
    -w $(pwd) fedebev/protobuf-node:latest \
    -I=${PROTO_PATH} --js_out="import_style=commonjs,binary:${OUT_DIR}"  --ts_out="service=grpc-node,mode=grpc-js:${OUT_DIR}" --grpc_out="grpc_js:${OUT_DIR}" ${FILES}
```

node:

```shell script
docker run --rm \
    -v $(pwd):$(pwd) \
    -w $(pwd) fedebev/protobuf-node:latest \
    -I=${PROTO_PATH} --js_out="import_style=commonjs,binary:${OUT_DIR}" --grpc_out="grpc_js:${OUT_DIR}" ${FILES}
```

### improbable-eng/grpc-web

Generate files for to be used with [@improbable-eng/grpc-web](https://www.npmjs.com/package/@improbable-eng/grpc-web)

typescript:

```shell script
docker run --rm \
    -v $(pwd):$(pwd) \
    -w $(pwd) fedebev/protobuf-node:latest \
    -I=${PROTO_PATH} --js_out="import_style=commonjs,binary:${OUT_DIR}"  --ts_out="service=grpc-web:${OUT_DIR}" --grpc_out="${OUT_DIR}" ${FILES}
```

javascript:

```shell script
docker run --rm \
    -v $(pwd):$(pwd) \
    -w $(pwd) fedebev/protobuf-node:latest \
    -I=${PROTO_PATH} --js_out="import_style=commonjs,binary:${OUT_DIR}" --grpc_out="${OUT_DIR}" ${FILES}
```

### grpc-web

Generate files for to be used with [grpc-web](https://www.npmjs.com/package/grpc-web)

typescript:

```shell script
docker run --rm \
    -v $(pwd):$(pwd) \
    -w $(pwd) fedebev/protobuf-node:latest \
    -I=${PROTO_PATH} --js_out="import_style=commonjs,binary:${OUT_DIR}"  --grpc-web_out="import_style=commonjs+dts,mode=grpcwebtext:${OUT_DIR}" ${FILES}
```

javascript:

```shell script
docker run --rm \
    -v $(pwd):$(pwd) \
    -w $(pwd) fedebev/protobuf-node:latest \
    -I=${PROTO_PATH} --js_out="import_style=commonjs,binary:${OUT_DIR}"  --grpc-web_out="import_style=commonjs,mode=grpcwebtext:${OUT_DIR}" ${FILES}
```
