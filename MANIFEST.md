# MANIFEST

Paged memory index. Claude reads this first, then fetches only unbracketed files.

**Convention:**
- No brackets → active, fetch the file this session
- `[label]` → exists, don't fetch unless the summary triggers a need

---

| topic | file | summary |
|---|---|---|
| Phase 1 Bicep | memory/azure-phase1-bicep.md | VNet + NSG + Private DNS Zone + Ubuntu B1s VM. Mirrors t630 homelab. Deploy with `scripts/deploy.sh` |
| Deploy & teardown scripts | memory/scripts.md | `deploy.sh` — prompts for SSH key, creates RG, runs Bicep. `teardown.sh` — confirms before deleting RG |
| [reference] Homelab → Azure mapping | memory/homelab-azure-mapping.md | Full table: UFW→NSG, Pi-hole→DNS Zone, Unbound→Azure DNS, WireGuard→VPN Gateway, Uptime Kuma→Azure Monitor, GitHub Actions→Azure CLI |
| [reference] AZ-104 study notes | memory/az104-notes.md | Exam objectives mapped to this lab. VNets, NSGs, DNS, VMs, VPN Gateway, RBAC, Monitor |
| [draft] Phase 2 — deploy pipeline | memory/phase2-pipeline.md | GitHub Actions → Azure CLI → VM. Service principal, Key Vault secrets, rolling deploys |
| [draft] Phase 3 — monitoring | memory/phase3-monitoring.md | Azure Monitor alerts, Log Analytics workspace, Uptime Kuma on VM vs native Azure |
