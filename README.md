# Documentation Rendering Tools

# Building
```
podman build -t doc-rendering-tools-build:latest --target=deliver .
```

# Loading
```
podman run --rm -p 9000:8000 doc-rendering-tools-build:latest
```

```
curl http://localhost:9000/doc-rendering-tools-img.tar.gz | gunzip | podman load
wget http://localhost:9000/doc-rendering-tools-img.tar.gz
```

# Running
```
alias drt='podman run --rm -it --workdir /work -v "$(pwd):/work:Z" --tmpfs=/tmp localhost/doc-rendering-tools:latest'
drt pandoc --list-output-formats | less
drt pandoc README.md -t html5 -s -o README.html
drt pandoc README.md -o README.pdf
```
