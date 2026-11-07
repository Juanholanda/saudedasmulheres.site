#!/usr/bin/env bash
# Teste de fumaça de todas as ferramentas. Rode: bash scripts/testar-tudo.sh
set -uo pipefail
cd "$(dirname "$0")/.."
export HYPERFRAMES_NO_TELEMETRY=1 DO_NOT_TRACK=1
mkdir -p out samples
ok=0; fail=0
passo() { # passo "nome" comando...
  local nome="$1"; shift
  if "$@" >/tmp/passo.log 2>&1; then echo "✅ $nome"; ok=$((ok+1)); else echo "❌ $nome"; tail -5 /tmp/passo.log; fail=$((fail+1)); fi
}

# Chromium: usa o do sistema/Playwright se existir (senão o Remotion baixa o próprio)
CH=$(ls /opt/pw-browsers/chromium_headless_shell-*/chrome-headless-shell-linux64/chrome-headless-shell 2>/dev/null | head -1 || true)
REM_ARGS=(--log=error); [ -n "$CH" ] && REM_ARGS+=(--browser-executable="$CH" --chrome-mode=headless-shell)

passo "FFmpeg (versão + libx264/libass)" bash -c 'ffmpeg -version | head -1 && ffmpeg -hide_banner -buildconf | grep -q libx264 && ffmpeg -hide_banner -buildconf | grep -q libass'
passo "yt-dlp (versão)"                  .venv/bin/yt-dlp --version
passo "Whisper (import + CLI)"           bash -c '.venv/bin/python -c "import whisper" && .venv/bin/whisper --help'
passo "Remotion (render MP4)"            npx remotion render remotion/src/index.ts TesteVideo out/remotion-teste.mp4 "${REM_ARGS[@]}"
passo "Hyperframes (lint)"               bash -c 'cd hyperframes-teste && npx hyperframes lint'
passo "Hyperframes (render MP4)"         bash -c 'cd hyperframes-teste && npx hyperframes render -o ../out/hyperframes-teste.mp4 -q draft'
passo "FFmpeg: gerar fala de teste"      ffmpeg -v error -y -f lavfi -i "flite=text='Hello. This is a test of the video editor. Whisper is transcribing this audio correctly.':voice=slt" -ar 16000 -ac 1 samples/fala-teste.wav
passo "Whisper: transcrever (modelo tiny)" .venv/bin/whisper samples/fala-teste.wav --model tiny --language en --device cpu --fp16 False --output_dir out/whisper --output_format srt
passo "FFmpeg: vídeo + áudio + legenda"  ffmpeg -v error -y -stream_loop 1 -i out/remotion-teste.mp4 -i samples/fala-teste.wav -t 5.8 \
  -vf "subtitles=out/whisper/fala-teste.srt:force_style='FontName=DejaVu Sans,FontSize=9,Bold=1,Alignment=2,MarginV=45,MarginL=12,MarginR=12,Outline=1'" \
  -c:v libx264 -preset veryfast -crf 20 -pix_fmt yuv420p -c:a aac -shortest out/pipeline-final.mp4

echo; echo "Resultado: $ok ok, $fail falhas"; [ "$fail" -eq 0 ]
