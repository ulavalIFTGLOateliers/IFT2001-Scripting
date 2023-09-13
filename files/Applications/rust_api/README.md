# rust_api

## Run

```shell
# Install dependencies
apt update; apt install -y libpq-dev
# Build
cargo build --release
# Run
./target/release/rust_api/
```

## Test it

```shell
# Create document
curl -X POST -H "Content-Type: application/json" -d '{"title": "Attention is all you need", "url": "https://arxiv.org/abs/1706.03762"}' http://localhost:8081/documents
# Query all documents
curl http://localhost:8081/documents
```
