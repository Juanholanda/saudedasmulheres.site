# Video Studio

Editor e criador de vídeos com IA, nesta pasta.

| Ferramenta | Para quê | Onde |
|---|---|---|
| **Remotion** | Vídeos programados em React (reels, títulos, dados) | `remotion/` |
| **Hyperframes** (HeyGen) | Vídeos a partir de HTML + GSAP, ótimo p/ agentes de IA | `hyperframes-teste/` |
| **FFmpeg** | Cortar, juntar, converter, legendar, áudio | sistema |
| **Whisper** | Transcrição / legendas (`.srt`) | `.venv/bin/whisper` |
| **yt-dlp** | Baixar vídeos/áudios de links | `.venv/bin/yt-dlp` |

## Comandos

```bash
bash scripts/setup.sh          # instala tudo (npm + venv Python)
bash scripts/testar-tudo.sh    # teste de fumaça de todas as ferramentas

npm run remotion:studio        # preview do Remotion
npx remotion render remotion/src/index.ts TesteVideo out/video.mp4
cd hyperframes-teste && npx hyperframes render -o ../out/video.mp4

.venv/bin/whisper audio.mp4 --model small --language pt --output_format srt
.venv/bin/yt-dlp -f "bv*+ba/b" -o "out/%(title)s.%(ext)s" URL
```

## Notas

- Use sempre GSAP **local** (`lib/gsap.min.js`) no Hyperframes, não o CDN: renderiza offline.
- Modelos Whisper: `tiny` (teste) < `base` < `small` (bom p/ português) < `medium` < `large`.
- `node_modules/`, `.venv/` (~5,6 GB) e `out/` não vão para o git.
