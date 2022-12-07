FROM docker.io/nixos/nix:latest as builder

WORKDIR /build
ADD flake.* /build/

RUN nix --extra-experimental-features "nix-command flakes" build '.#container' && cp result doc-rendering-tools-img.tar.gz

#####################################################################
FROM docker.io/nixos/nix:latest as deliver
WORKDIR /serve
COPY --from=builder /build/doc-rendering-tools-img.tar.gz /serve/

RUN nix-env -iA nixpkgs.python311
CMD [ "python3", "-m", "http.server" ]
EXPOSE 8000