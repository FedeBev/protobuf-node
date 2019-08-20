# What is?
Docker image based on node-alpine image with protobuf

## Why?
For example for build pipeline of node/typescript project that use static grpc code generation 

## Plugin versions

| Plugin | Version |
|:-:|:-:|
| ts-protoc-gen | 0.10.0 |
| protoc-gen-grpc-web | 1.0.6 |

## Usage examples

### Typescript
```bash
# Directory to write generated code to (.js and .d.ts files)
TS_OUT_DIR="./generated/ts"
mkdir -p $TS_OUT_DIR

docker run --rm -v $(pwd):$(pwd) -w $(pwd) fedebev/protobuf-node:p3.7.0-n10.15:latest \
    -e TS_OUT_DIR=$TS_OUT_DIR \
    node-proto:latest \
    bash -c  'protoc -I ./ --plugin="protoc-gen-ts=${PROTOC_GEN_TS_PATH}" --js_out="import_style=commonjs,binary:${TS_OUT_DIR}" --ts_out="service=true:${TS_OUT_DIR}" ./myProto.proto'

```

**NOTE**: Variable `PROTOC_GEN_TS_PATH` is already defined in the container

For more informations about TS plugin see [ts-protoc-gen](https://www.npmjs.com/package/ts-protoc-gen)

### Javascript web

```bash
docker run --rm -v $(pwd):$(pwd) -w $(pwd) fedebev/protobuf-node:p3.7.0-n10.15:latest \
    protoc user-manager.proto \
    -I ./ \
    --js_out=import_style=commonjs:$JS_OUT_DIR \
    --grpc-web_out=import_style=commonjs,mode=grpcwebtext:$JS_OUT_DIR
```

For more information about js web build see [grpc-web](https://github.com/grpc/grpc-web)