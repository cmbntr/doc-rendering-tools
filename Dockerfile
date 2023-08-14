FROM docker.io/nixos/nix:latest as builder

WORKDIR /build
ADD flake.* /build/

RUN nix --extra-experimental-features "nix-command flakes" build && cp result doc-rendering-tools-img.tar.gz

#####################################################################
FROM docker.io/nixos/nix:latest as deliver
WORKDIR /serve
COPY --from=builder /build/doc-rendering-tools-img.tar.gz /serve/

RUN nix-env -iA nixpkgs.dufs
CMD [ "dufs", "-p", "8000", "." ]
EXPOSE 8000
