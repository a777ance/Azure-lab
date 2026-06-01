#!/usr/bin/env bash
# Deploy Phase 1 Azure homelab lab
# Prerequisites: az login, az bicep install

set -euo pipefail

RESOURCE_GROUP="rg-homelab-lab"
LOCATION="eastus"
PARAMS_FILE="bicep/main.parameters.json"

# Prompt for SSH key if not set in params file
if grep -q 'REPLACE_WITH_YOUR_SSH_PUBLIC_KEY' "$PARAMS_FILE"; then
  echo "Paste your SSH public key (cat ~/.ssh/id_rsa.pub):" 
  read -r SSH_KEY
  # Temporarily inject the key
  PARAMS_OVERRIDE="adminSshPublicKey=$SSH_KEY"
else
  PARAMS_OVERRIDE=""
fi

echo "Creating resource group: $RESOURCE_GROUP in $LOCATION..."
az group create \
  --name "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --output table

echo "Deploying Bicep template..."
az deployment group create \
  --resource-group "$RESOURCE_GROUP" \
  --template-file bicep/main.bicep \
  --parameters @"$PARAMS_FILE" \
  ${PARAMS_OVERRIDE:+--parameters "$PARAMS_OVERRIDE"} \
  --output table

echo ""
echo "Done! Outputs:"
az deployment group show \
  --resource-group "$RESOURCE_GROUP" \
  --name main \
  --query properties.outputs \
  --output table
