#!/usr/bin/env bash

# set -e  | aborta o script se qualquer comando retornar erro (exit code != 0)
# set -u  | trata variável não definida como erro (evita bugs silenciosos)
# set -o pipefail | faz um pipe falhar se qualquer comando da cadeia falhar, não só o último
set -euo pipefail

PLUGINS=(
  "https://github.com/navidrome/apple-music-plugin/releases/download/v0.2.0/apple-music.ndp"
  "https://github.com/metalheim/navidrome-plugin-artist-nfo-metadata/releases/download/v1.3.0/artist-nfo-metadata.ndp"
  "https://github.com/sunsetroute1/navidrome-coverartarchive-plugin/releases/download/v1.0.0/coverartarchive.ndp"
  "https://github.com/J0R6IT0/navidrome-lyrics-plugin/releases/download/v8.1.0/nd-lyrics.ndp"
)

echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║     Navidrome / Spoty-Vella - Plugins downloader     ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""

# --------------------------------------------------------------------------
# Tenta sugerir o diretório de plugins do .env, se existir
# --------------------------------------------------------------------------
DEFAULT_DIR=""
if [ -f ".env" ]; then
  HOST_DATA_ENV=$(grep -E '^HOST_DATA=' .env | cut -d= -f2- | tr -d '"'"'" | xargs)
  [ -n "$HOST_DATA_ENV" ] && DEFAULT_DIR="${HOST_DATA_ENV}/plugins"
fi

if [ -n "$DEFAULT_DIR" ]; then
  read -rp "Caminho para salvar os plugins [${DEFAULT_DIR}]: " DEST
  DEST="${DEST:-$DEFAULT_DIR}"
else
  read -rp "Caminho para salvar os plugins: " DEST
  if [ -z "$DEST" ]; then
    echo "Caminho não informado. Abortando."
    exit 1
  fi
fi

# --------------------------------------------------------------------------
# Cria o diretório se não existir
# --------------------------------------------------------------------------
if [ ! -d "$DEST" ]; then
  echo ""
  echo "Diretório não existe. Criando: $DEST"
  mkdir -p "$DEST"
fi

echo ""
echo "Baixando plugins em: $DEST"
echo "──────────────────────────────────────────────────────"

# --------------------------------------------------------------------------
# Download
# --------------------------------------------------------------------------
for URL in "${PLUGINS[@]}"; do
  FILENAME=$(basename "$URL")
  echo ""
  echo "  ➜  $FILENAME"
  wget \
    --quiet \
    --show-progress \
    --continue \
    --output-document="${DEST}/${FILENAME}" \
    "$URL"
done

echo ""
echo "──────────────────────────────────────────────────────"
echo "Plugins baixados com sucesso!"
echo ""
echo "   Plugins instalados em: $DEST"
echo ""
ls -lh "$DEST"/*.ndp 2>/dev/null || true
echo ""
echo "Aguarde o reload automático"
echo "para que os plugins sejam carregados."
echo ""