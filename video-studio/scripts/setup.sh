#!/usr/bin/env bash
# Instala tudo do estúdio de vídeo nesta pasta. Rode: bash scripts/setup.sh
set -euo pipefail
cd "$(dirname "$0")/.."

command -v ffmpeg >/dev/null || { echo ">> Instalando FFmpeg (apt)"; apt-get install -y ffmpeg; }

echo ">> Node: Remotion + Hyperframes"
npm install --no-audit --no-fund
cp -f node_modules/gsap/dist/gsap.min.js hyperframes-teste/lib/gsap.min.js 2>/dev/null || true

echo ">> Python: yt-dlp + Whisper (venv em .venv)"
[ -d .venv ] || python3 -m venv .venv
.venv/bin/pip install -q --upgrade pip
.venv/bin/pip install -q -r requirements.txt
echo "Pronto. Teste com: bash scripts/testar-tudo.sh"
