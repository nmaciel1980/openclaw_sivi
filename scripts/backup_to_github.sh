#!/bin/bash
set -euo pipefail
# backup_to_github.sh — cria snapshot do workspace, envia para repo e organiza backups (mantém últimos 3)
WORKDIR="/home/node/.openclaw/workspace"
source "$WORKDIR/.env"
TF=$(date -u +"%Y-%m-%d_%H%M%SZ")
TMP=/tmp/openclaw_backup_$TF
REMOTE="https://$GITHUB_TOKEN@github.com/nmaciel1980/openclaw_sivi.git"
BRANCH="backup_$TF"
# preparar temp
rm -rf "$TMP" && mkdir -p "$TMP"
( cd "$WORKDIR" && tar -cf - . --exclude='./.git' ) | ( cd "$TMP" && tar -xf - )
cd "$TMP"
# commitar backup em branch temporária e enviar
git init -q
git add -A
git commit -m "backup: workspace $TF" || true
git remote add origin "$REMOTE" || true
git fetch origin --depth=1 || true
git branch -M "$BRANCH"
git push -u origin HEAD:refs/heads/$BRANCH --force
# Atualizar main para apontar para este commit (force update)
SHA=$(git rev-parse HEAD)
curl -s -X PATCH -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/nmaciel1980/openclaw_sivi/git/refs/heads/main \
  -d "{\"sha\":\"$SHA\",\"force\":true}"
# Criar pasta de snapshot no main contendo a cópia atual
CLONE=/tmp/clone_openclaw_$TF
rm -rf "$CLONE"
git clone "$REMOTE" "$CLONE" >/dev/null 2>&1
cd "$CLONE"
git checkout main
SNAPDIR="backup_$TF"
mkdir -p "$SNAPDIR"
# copiar conteúdo do root para SNAPDIR, excluindo a própria pasta de backups e .git
shopt -s dotglob
for item in *; do
  if [[ "$item" == ".git" ]] || [[ "$item" == backup_* ]]; then
    continue
  fi
  cp -r "$item" "$SNAPDIR/" || true
done
git add "$SNAPDIR"
if git commit -m "add backup folder $SNAPDIR"; then
  git push origin main
fi
# Limpar backups antigos — manter apenas 3 pastas backup_*
BACKUPS=( $(ls -1d backup_* 2>/dev/null | sort) )
COUNT=${#BACKUPS[@]}
if (( COUNT > 3 )); then
  REMOVE_COUNT=$((COUNT-3))
  for i in $(seq 0 $((REMOVE_COUNT-1))); do
    rm -rf "${BACKUPS[$i]}"
    git rm -r "${BACKUPS[$i]}" || true
  done
  git commit -m "cleanup: remove oldest backups, keep last 3" || true
  git push origin main || true
fi
# finished
exit 0
