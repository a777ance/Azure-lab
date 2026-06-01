# Azure-lab

Azure learning home-lab — mirrors my local homelab stack to Azure equivalents.

## Stack Mapping

| Homelab | Azure Equivalent | AZ-104 Topic |
|---|---|---|
| Static IP (DHCP reservation) | Azure Static Private IP | Virtual Networking |
| LAN subnet 192.168.1.0/24 | VNet + Subnet | Virtual Networks |
| UFW rules | Network Security Group (NSG) | NSGs |
| Pi-hole DNS | Azure Private DNS Zone | Azure DNS |
| Unbound recursive resolver | Azure DNS Resolver | Azure DNS |
| WireGuard VPN | Azure VPN Gateway (P2S) | VPN Gateway |
| Uptime Kuma | Azure Monitor + Alerts | Monitoring |
| GitHub Actions → SSH → reload | GitHub Actions → Azure CLI | AZ-400 preview |

## Phases

### Phase 1 — VNet + DNS + VM (AZ-104)

Provisions the core network and a Linux VM equivalent to the HP t630.

See [`bicep/`](./bicep/)

### Phase 2 — Monitoring + Deploy pipeline (AZ-204 + AZ-400)

GitHub Actions → Azure CLI deployment, Azure Monitor, Log Analytics.

_Coming soon._

## Prerequisites

- Azure CLI: `az login`
- Azure subscription (free account works: $200 credit, 30 days)
- Bicep CLI: `az bicep install`

## Deploy Phase 1

```bash
# Create resource group
az group create --name rg-homelab-lab --location eastus

# Deploy
az deployment group create \
  --resource-group rg-homelab-lab \
  --template-file bicep/main.bicep \
  --parameters @bicep/main.parameters.json
```

## Tear Down

```bash
az group delete --name rg-homelab-lab --yes --no-wait
```
