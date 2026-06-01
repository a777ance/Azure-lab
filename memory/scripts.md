# Deploy & Teardown Scripts

## scripts/deploy.sh

- Checks if `main.parameters.json` still has the placeholder SSH key; if so, prompts for it
- Creates resource group `rg-homelab-lab` in `eastus`
- Runs `az deployment group create` with Bicep template
- Prints outputs table on success

## scripts/teardown.sh

- Requires typing the resource group name to confirm
- Runs `az group delete --no-wait` (async — returns immediately)
- Check deletion: `az group show --name rg-homelab-lab --query properties.provisioningState`

## Prerequisites

```bash
az login
az bicep install
```
