#!/usr/bin/env bash
set -euo pipefail

# 1. Installera flyctl
curl -L https://fly.io/install.sh | sh
export FLYCTL_INSTALL="$HOME/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# 2. Logga in (öppnar URL i ny flik — godkänn där)
fly auth login

# 3. Skapa appen (läser fly.toml, deployar inte än)
fly launch --no-deploy --copy-config --yes

# 4. Persistent volym för chathistorik, RAG-index, användare
fly volumes create openwebui_data --size 3 --region arn --yes

# 5. Secrets — byt BERGET_KEY mot din riktiga nyckel innan körning
fly secrets set \
  OPENAI_API_KEY="$BERGET_KEY" \
  WEBUI_SECRET_KEY="$(openssl rand -hex 32)"

# 6. Deploya
fly deploy

# 7. Öppna i webbläsare
fly open
