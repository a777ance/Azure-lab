#!/usr/bin/env bash
# Tear down the entire lab — deletes the resource group and everything in it
# This is the Azure equivalent of shutting down the t630

set -euo pipefail

RESOURCE_GROUP="rg-homelab-lab"

echo "WARNING: This will delete $RESOURCE_GROUP and ALL resources inside it."
read -rp "Type the resource group name to confirm: " CONFIRM

if [[ "$CONFIRM" != "$RESOURCE_GROUP" ]]; then
  echo "Aborted."
  exit 1
fi

az group delete \
  --name "$RESOURCE_GROUP" \
  --yes \
  --no-wait

echo "Deletion initiated. Resources will be removed in the background."
echo "Check status: az group show --name $RESOURCE_GROUP --query properties.provisioningState"
