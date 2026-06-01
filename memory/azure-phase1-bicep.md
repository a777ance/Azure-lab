# Phase 1 — Bicep Templates

Entry point: `bicep/main.bicep`
Parameters: `bicep/main.parameters.json` — fill in `adminSshPublicKey` before deploying.

## Module structure

```
bicep/
├── main.bicep                  ← wires modules, exposes outputs
├── main.parameters.json        ← fill in SSH key here
└── modules/
    ├── vnet.bicep              ← VNet + Subnets + NSG
    ├── dns.bicep               ← Private DNS Zone (homelab.internal)
    └── vm.bicep                ← Ubuntu 24.04 B1s, static private IP 10.0.1.10
```

## Key values

| resource | value |
|---|---|
| VNet address space | 10.0.0.0/16 |
| main-subnet | 10.0.1.0/24 |
| GatewaySubnet | 10.0.255.0/27 |
| VM private IP | 10.0.1.10 (static) |
| VM size | Standard_B1s (free tier eligible) |
| OS | Ubuntu 24.04 LTS |
| DNS zone | homelab.internal |
| WireGuard port | 51820/udp |

## NSG rules (mirrors UFW)

| rule | port | protocol | source |
|---|---|---|---|
| allow-ssh | 22 | TCP | * (restrict to your IP in prod) |
| allow-wireguard | 51820 | UDP | * |
| allow-dns-inbound | 53 | * | VirtualNetwork |
| allow-uptime-kuma | 3001 | TCP | VirtualNetwork |
| deny-all-inbound | * | * | * |

## Deploy

```bash
az group create --name rg-homelab-lab --location eastus
az deployment group create \
  --resource-group rg-homelab-lab \
  --template-file bicep/main.bicep \
  --parameters @bicep/main.parameters.json
```

## Outputs

- `vmPublicIp` — SSH target
- `vmPrivateIp` — 10.0.1.10
- `dnsZoneName` — homelab.internal
- `sshCommand` — ready-to-run SSH string
