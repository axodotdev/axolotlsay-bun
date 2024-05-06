#!/bin/sh

set -eu

EXE_BASENAME=axolotlsay-bun

install_bun_windows() {
  powershell -c "irm bun.sh/install.ps1 | iex"
}

install_bun_unix() {
  curl -fsSL https://bun.sh/install | bash
}

# Don't install bun in interactive shells; just assume we have it
if [ -z "${CI:-}" ] && ! type bun >/dev/null; then
  case "$(uname -s)" in
    MINGW* | MSYS* | CYGWIN* | Windows_NT)
      install_bun_windows
      ;;
    *)
      install_bun_unix
      ;;
    esac

  # So we don't have to reload the config it writes
  # Note: this is also valid for Windows, which also places
  # it in $HOME
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$HOME/.bun/bin/bun"
fi

bun install

args=

# If we're building for cargo-dist, specify which target to build and what the
# filename should be. cargo-dist will expect one output with a known filename.
if [ -n "${CARGO_DIST_TARGET:-}" ]; then
    case "${CARGO_DIST_TARGET}" in
        x86_64-pc-windows-msvc)
            args="--target bun-windows-x64 --outfile ${EXE_BASENAME}.exe"
            ;;
        aarch64-apple-darwin)
            args="--target bun-darwin-arm64 --outfile ${EXE_BASENAME}"
            ;;
        x86_64-apple-darwin)
            args="--target bun-darwin-x64 --outfile ${EXE_BASENAME}"
            ;;
        aarch64-unknown-linux-gnu)
            args="--target bun-linux-arm64 --outfile ${EXE_BASENAME}"
            ;;
        x86_64-unknown-linux-gnu)
            args="--target bun-linux-x64 --outfile ${EXE_BASENAME}"
            ;;
        *)
            echo "Platform not supported: ${CARGO_DIST_TARGET}"
            exit 1
        esac
fi

bun build ./index.js --compile $args
