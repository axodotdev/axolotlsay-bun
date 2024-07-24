#!/bin/sh

set -eu

EXE_BASENAME=axolotlsay-js

# Install devDependencies to get bun
npm install --include=dev

bun_args=

# If we're building for cargo-dist, specify which target to build and what the
# filename should be. cargo-dist will expect one output with a known filename.
if [ -n "${CARGO_DIST_TARGET:-}" ]; then
    case "${CARGO_DIST_TARGET}" in
        x86_64-pc-windows-msvc)
            bun_args="--target bun-windows-x64 --outfile ${EXE_BASENAME}.exe"
            ;;
        aarch64-apple-darwin)
            bun_args="--target bun-darwin-arm64 --outfile ${EXE_BASENAME}"
            ;;
        x86_64-apple-darwin)
            bun_args="--target bun-darwin-x64 --outfile ${EXE_BASENAME}"
            ;;
        aarch64-unknown-linux-gnu)
            bun_args="--target bun-linux-arm64 --outfile ${EXE_BASENAME}"
            ;;
        x86_64-unknown-linux-gnu)
            bun_args="--target bun-linux-x64 --outfile ${EXE_BASENAME}"
            ;;
        aarch64-pc-windows-msvc)
            echo "bun doesn't currently provide ARM binaries for Windows; unable to build"
            exit 1
            ;;
        *)
            echo "Platform not supported: ${CARGO_DIST_TARGET}"
            exit 1
        esac
fi

npm run-script build -- $bun_args
