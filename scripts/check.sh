#!/usr/bin/env bash
set -euo pipefail
URL='https://adue.quiksoft.nl/.well-known/com.apple.remotemanagement'
printf 'Check direct discovery response:\n'
curl -sS -i --max-redirs 0 "$URL?user-identifier=example%40quiksoft.nl&model-family=iPhone"
printf '\n\nCheck root redirect response:\n'
curl -sS -i --max-redirs 0 'https://quiksoft.nl/.well-known/com.apple.remotemanagement?user-identifier=example%40quiksoft.nl&model-family=iPhone'
printf '\nEXPECTED: direct endpoint HTTP 200 + Content-Type application/json + exact uploaded JSON; root HTTP 301/302 with Location pointing to adue.quiksoft.nl and retaining parameters. GitHub Pages does not offer controls to guarantee either requirement.\n'
