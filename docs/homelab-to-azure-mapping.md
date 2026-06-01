# Homelab → Azure Mapping

A study guide that maps your physical homelab to Azure equivalents.
Useful for AZ-104 and AZ-204 exam prep.

## Network

| Homelab concept | Azure resource | Notes |
|---|---|---|
| LAN (192.168.1.0/24) | Virtual Network (VNet) | Azure VNet uses 10.0.0.0/16 here |
| VLAN / subnet | Subnet | Subnets carved out of the VNet address space |
| Router/default gateway | Azure-managed gateway | Implicit in Azure — no resource to create |
| DHCP server | Azure-managed DHCP | Automatic in Azure subnets |
| DHCP reservation (static IP) | Static private IP on NIC | Set `privateIPAllocationMethod: Static` |
| Public WAN IP | Public IP Address resource | Can be static or dynamic |
| DynDNS / DDNS | Public IP DNS label | Free FQDN: `<label>.<region>.cloudapp.azure.com` |

## Firewall

| UFW rule | NSG equivalent |
|---|---|
| `ufw default deny incoming` | Implicit deny in NSG (all blocked unless allowed) |
| `ufw allow 22/tcp` | Inbound rule: TCP 22, Allow |
| `ufw allow 51820/udp` | Inbound rule: UDP 51820, Allow |
| `ufw allow from 192.168.1.0/24 to any port 53` | Inbound rule: UDP+TCP 53, source=VirtualNetwork |
| `ufw allow out` | NSG Outbound: default allow (Azure default) |

NSG rules have a **priority** (100–4096). Lower = evaluated first. Equivalent to ufw rule order.

## DNS

| Homelab component | Azure equivalent | Notes |
|---|---|---|
| Pi-hole | Azure Private DNS Zone | Resolves private hostnames within VNet |
| Pi-hole upstream → Unbound | Azure DNS (168.63.129.16) | Azure's recursive resolver, always available |
| Unbound DNSSEC | Azure DNS supports DNSSEC | Built-in, no config needed |
| Pi-hole custom DNS record | Private DNS Zone A record | e.g., `gateway.homelab.internal → 10.0.1.1` |
| Pi-hole auto-hostname | DNS auto-registration | Enable `registrationEnabled: true` on VNet link |
| Pi-hole ad-blocking | N/A in this phase | Azure Firewall FQDN filtering (premium, expensive) |

## Compute

| Homelab | Azure | Notes |
|---|---|---|
| HP t630 thin client | Azure VM (B1s) | 1 vCPU, 1GB RAM — free tier eligible |
| Ubuntu 24.04 LTS | Same image available | `Canonical:0001-com-ubuntu-server-noble:24_04-lts-gen2` |
| SSH key auth | SSH key auth on VM | `disablePasswordAuthentication: true` |
| SSH access | Same — via public IP | Restrict source IP in NSG for production |

## VPN

| Homelab | Azure | Notes |
|---|---|---|
| WireGuard (self-hosted) | Azure VPN Gateway (P2S) | Managed service, ~$27/mo for Basic SKU |
| WireGuard on t630 | WireGuard on Azure VM | DIY option — same as homelab, cheaper |
| wg0.conf peers | VPN Gateway client config | Downloaded from Azure portal |
| UDP 51820 | UDP 51820 (or IKEv2/SSTP) | Azure VPN Gateway uses IKEv2/SSTP/OpenVPN by default |

**Recommendation for the lab**: Install WireGuard directly on the VM (same as homelab) rather than paying for VPN Gateway. Use VPN Gateway for the AZ-104 exam study but not for cost-sensitive labs.

## Monitoring

| Homelab | Azure | Notes |
|---|---|---|
| Uptime Kuma | Azure Monitor + Alerts | Built-in — no separate install |
| Uptime Kuma dashboard (port 3001) | Azure Monitor Workbooks | Visualize metrics in portal |
| Prometheus + Grafana | Azure Monitor + Metrics | Optional: can still run on VM |

## Deploy Pipeline

| Homelab | Azure | Notes |
|---|---|---|
| GitHub Actions → SSH → systemctl reload | GitHub Actions → Azure CLI | Uses `azure/login` action + service principal |
| `.env` secrets in repo | Azure Key Vault | Managed secrets store |
| Manual `git pull` on t630 | Azure Automation or GitHub Actions | Fully automated in cloud |

## Cost Estimate (Phase 1)

| Resource | SKU | Monthly cost |
|---|---|---|
| VM (B1s) | Standard_B1s | Free tier (750 hrs/mo for 12 months) |
| Public IP | Standard Static | ~$3.65/mo |
| VNet | N/A | Free |
| Private DNS Zone | Per zone | ~$0.50/mo + $0.40/million queries |
| OS Disk (32GB) | Standard LRS | Free tier (2x 64GB for 12 months) |
| **Total** | | **~$4–5/mo** (free for first 12 months with free account) |
