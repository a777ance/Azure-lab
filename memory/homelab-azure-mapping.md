# Homelab → Azure Mapping

## Network

| Homelab | Azure resource |
|---|---|
| LAN 192.168.1.0/24 | VNet 10.0.0.0/16 |
| VLAN / subnet | Subnet |
| DHCP reservation (static IP) | Static private IP on NIC |
| Public WAN IP | Public IP Address resource |
| DynDNS | Public IP DNS label (`<label>.<region>.cloudapp.azure.com`) |

## Firewall

| UFW | NSG |
|---|---|
| `ufw default deny incoming` | Implicit deny (NSG blocks all unless allowed) |
| `ufw allow 22/tcp` | Inbound TCP 22, Allow |
| `ufw allow 51820/udp` | Inbound UDP 51820, Allow |
| `ufw allow from 192.168.1.0/24 port 53` | Inbound 53, source=VirtualNetwork |
| Priority / rule order | NSG priority number (lower = first) |

## DNS

| Homelab | Azure |
|---|---|
| Pi-hole custom DNS records | Private DNS Zone A records |
| Pi-hole local hostname resolution | DNS auto-registration (registrationEnabled: true) |
| Unbound recursive resolver | Azure DNS 168.63.129.16 (built-in) |
| Unbound DNSSEC | Azure DNS DNSSEC (built-in) |

## Compute

| Homelab | Azure |
|---|---|
| HP t630 thin client | Standard_B1s VM |
| Ubuntu 24.04 LTS | Same image |
| SSH key auth | `disablePasswordAuthentication: true` |

## VPN

| Homelab | Azure |
|---|---|
| WireGuard self-hosted | WireGuard on VM (same, cheapest) or Azure VPN Gateway (~$27/mo) |
| wg0.conf peers | VPN Gateway client config or wg0.conf on VM |

## Monitoring

| Homelab | Azure |
|---|---|
| Uptime Kuma (port 3001) | Azure Monitor + Alerts (built-in) |
| Prometheus + Grafana | Azure Monitor Metrics + Workbooks |

## Pipeline

| Homelab | Azure |
|---|---|
| GitHub Actions → SSH → systemctl reload | GitHub Actions → Azure CLI |
| `.env` secrets | Azure Key Vault |

## Cost (Phase 1)

| Resource | Cost |
|---|---|
| B1s VM | Free tier (750 hrs/mo, 12 months) |
| Standard Static Public IP | ~$3.65/mo |
| Private DNS Zone | ~$0.50/mo |
| OS Disk | Free tier (2×64GB, 12 months) |
| **Total** | **~$4–5/mo** (free year 1) |
