// Azure Homelab - Phase 1
// Mirrors: HP t630 homelab (Pi-hole + Unbound + WireGuard + Uptime Kuma)
// AZ-104 objectives: VNets, Subnets, NSGs, Private DNS, VMs

targetScope = 'resourceGroup'

@description('Azure region for all resources')
param location string = resourceGroup().location

@description('Admin username for the Linux VM')
param adminUsername string = 'azureuser'

@description('SSH public key for VM access (paste your ~/.ssh/id_rsa.pub)')
@secure()
param adminSshPublicKey string

@description('WireGuard listen port — matches your homelab default')
param wireguardPort int = 51820

var prefix = 'homelab'

// ─── Virtual Network ──────────────────────────────────────────────────────────
// Homelab equivalent: your 192.168.1.0/24 LAN
module vnet 'modules/vnet.bicep' = {
  name: 'vnet'
  params: {
    location: location
    prefix: prefix
    wireguardPort: wireguardPort
  }
}

// ─── Private DNS Zone ─────────────────────────────────────────────────────────
// Homelab equivalent: Pi-hole local DNS + Unbound recursive resolver
module dns 'modules/dns.bicep' = {
  name: 'dns'
  params: {
    vnetId: vnet.outputs.vnetId
  }
}

// ─── Linux VM ─────────────────────────────────────────────────────────────────
// Homelab equivalent: HP t630 thin client
module vm 'modules/vm.bicep' = {
  name: 'vm'
  params: {
    location: location
    prefix: prefix
    adminUsername: adminUsername
    adminSshPublicKey: adminSshPublicKey
    subnetId: vnet.outputs.mainSubnetId
    nsgId: vnet.outputs.nsgId
  }
}

// ─── Outputs ──────────────────────────────────────────────────────────────────
output vmPublicIp string = vm.outputs.publicIp
output vmPrivateIp string = vm.outputs.privateIp
output dnsZoneName string = dns.outputs.zoneName
output sshCommand string = 'ssh ${adminUsername}@${vm.outputs.publicIp}'
