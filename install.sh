#!/bin/bash
# SPDX-FileCopyrightText: 2026 Rafael Meira Gonçalves
# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
set -euo pipefail
umask 077
[[ "$(uname -s)" == Darwin ]] || { echo 'Este instalador exige macOS.' >&2; exit 1; }
case "$(uname -m)" in
  arm64) arch=arm64 ;;
  x86_64) arch=x64 ;;
  *) echo 'Arquitetura não suportada.' >&2; exit 1 ;;
esac
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$PATH"
if ! command -v node >/dev/null || ! command -v npm >/dev/null || ! command -v uv >/dev/null; then
  echo 'Instale Node.js 22+ (com npm) e uv. Com Homebrew: brew install node uv' >&2
  exit 1
fi
[[ "$(node -p 'process.arch')" == "$arch" ]] || { echo 'Use Node nativo para a arquitetura deste Mac (sem Rosetta).' >&2; exit 1; }
tmp=$(mktemp -d "${TMPDIR:-/tmp}/lagrange-install.XXXXXXXX")
trap 'rm -rf -- "$tmp"' EXIT
# Resolve once, so an intervening release cannot mix the archive with another checksum.
release="${LAGRANGE_RELEASE:-latest}"
if [[ "$release" == latest ]]; then
  endpoint=latest
elif [[ "$release" =~ ^v[0-9A-Za-z.+-]+$ ]]; then
  endpoint="tags/$release"
else
  echo 'Versão de instalação inválida.' >&2; exit 1
fi
curl --fail --silent --show-error --location --proto '=https' --tlsv1.2 \
  "https://api.github.com/repos/rafa210587/lagrange/releases/$endpoint" -o "$tmp/release.json"
base=$(node -e 'const fs=require("fs");const r=JSON.parse(fs.readFileSync(process.argv[1],"utf8"));if(!/^v[0-9A-Za-z.+-]+$/.test(r.tag_name))process.exit(1);process.stdout.write("https://github.com/rafa210587/lagrange/releases/download/"+r.tag_name)' "$tmp/release.json")
asset="lagrange-darwin-$arch.tar.gz"
for file in "$asset" "$asset.sha256"; do
  curl --fail --silent --show-error --location --proto '=https' --tlsv1.2 "$base/$file" -o "$tmp/$file"
done
expected=$(awk '{print $1}' "$tmp/$asset.sha256")
[[ "$expected" =~ ^[a-fA-F0-9]{64}$ ]] || { echo 'Checksum inválido.' >&2; exit 1; }
actual=$(shasum -a 256 "$tmp/$asset" | awk '{print $1}')
[[ "$actual" == "$expected" ]] || { echo 'Checksum divergente; instalação interrompida.' >&2; exit 1; }
mkdir "$tmp/package"
tar -xzf "$tmp/$asset" -C "$tmp/package"
node "$tmp/package/setup-macos.mjs"
