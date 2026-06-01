// Azure Private DNS Zone
// Homelab equivalent: Pi-hole local DNS + Unbound recursive resolver
//
// Pi-hole handles: ad-blocking, local hostnames (e.g. hp-t630.local)
// Unbound handles: recursive DNSSEC resolution (no upstream forwarder)
//
// Azure Private DNS Zone handles: private hostname resolution within the VNet
// Azure DNS (168.63.129.16) handles: recursive resolution for public names

param vnetId string

// Private DNS zone — resolves names like 'vm.homelab.internal' within the VNet
// Use .internal to avoid conflicts with real TLDs (.local is mDNS-reserved)
resource dnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'homelab.internal'
  location: 'global'
}

// Link the DNS zone to the VNet — VMs in the VNet will auto-resolve homelab.internal names
resource vnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: dnsZone
  name: 'homelab-vnet-link'
  location: 'global'
  properties: {
    virtualNetwork: {
      id: vnetId
    }
    // Auto-registration: VMs get a DNS record automatically when they join the VNet
    // Equivalent to Pi-hole auto-adding local hostnames
    registrationEnabled: true
  }
}

// Example A record — add more for each service you deploy
// Equivalent to Pi-hole custom DNS: hp-t630.local → 192.168.1.100
resource exampleRecord 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  parent: dnsZone
  name: 'gateway'
  properties: {
    ttl: 300
    aRecords: [
      {
        ipv4Address: '10.0.1.1'
      }
    ]
  }
}

output zoneName string = dnsZone.name
output zoneId string = dnsZone.id
