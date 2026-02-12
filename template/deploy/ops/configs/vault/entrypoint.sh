#!/bin/sh
# Entrypoint wrapper that loads Vault secrets before starting the app
# shellcheck disable=SC1090

SECRETS_FILE="/vault/secrets/.env"

# Only wait for secrets if vault-agent is likely running
if [ -f "$SECRETS_FILE" ]; then
  echo "Loading secrets from $SECRETS_FILE"
  set -a
  . "$SECRETS_FILE"
  set +a
elif [ -d "/vault/secrets" ]; then
  COUNTER=0
  while [ ! -f "$SECRETS_FILE" ] && [ $COUNTER -lt 5 ]; do
    sleep 1
    COUNTER=$((COUNTER + 1))
  done

  if [ -f "$SECRETS_FILE" ]; then
    echo "Loading secrets from $SECRETS_FILE"
    set -a
    . "$SECRETS_FILE"
    set +a
  fi
fi

# Execute the main command
exec "$@"
