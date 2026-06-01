// Virtual Network + Subnets + NSG
// Homelab equivalent: LAN (192.168.1.0/24), UFW rules

param location string
param prefix string
param wireguardPort int

// ─── VNet ─────────────────────────────────────────────────────────────────────
// 10.0.0.0/16 gives room to grow — add subnets as you add services
resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: '${prefix}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/16']
    }
    subnets: [
      {
        // Main subnet — VM lives here (equivalent to your 192.168.1.x devices)
        name: 'main-subnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
          networkSecurityGroup: {
            id: nsg.id
          }
        }
      }
      {
        // Reserved for Azure VPN Gateway — must be named exactly 'GatewaySubnet'
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '10.0.255.0/27'
        }
      }
    ]
  }
}

// ─── Network Security Group ───────────────────────────────────────────────────
// Homelab equivalent: UFW rules on the t630
// Priority: lower number = evaluated first (100-4096)
resource nsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: '${prefix}-nsg'
  location: location
  properties: {
    securityRules: [
      {
        // Allow SSH — equivalent to: ufw allow 22/tcp
        name: 'allow-ssh'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
          description: 'SSH access — restrict sourceAddressPrefix to your IP in production'
        }
      }
      {
        // Allow WireGuard UDP — equivalent to: ufw allow 51820/udp
        name: 'allow-wireguard'
        properties: {
          priority: 110
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Udp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '${wireguardPort}'
          description: 'WireGuard VPN'
        }
      }
      {
        // Allow DNS from within VNet — equivalent to: ufw allow from 192.168.1.0/24 to any port 53
        name: 'allow-dns-inbound'
        properties: {
          priority: 120
          direction: 'Inbound'
          access: 'Allow'
          protocol: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '53'
          description: 'DNS queries from within VNet only'
        }
      }
      {
        // Allow Uptime Kuma dashboard from within VNet
        name: 'allow-uptime-kuma'
        properties: {
          priority: 130
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3001'
          description: 'Uptime Kuma monitoring dashboard — VNet only'
        }
      }
      {
        // Deny all other inbound — equivalent to: ufw default deny incoming
        name: 'deny-all-inbound'
        properties: {
          priority: 4000
          direction: 'Inbound'
          access: 'Deny'
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          description: 'Default deny — matches UFW default deny incoming'
        }
      }
    ]
  }
}

output vnetId string = vnet.id
output mainSubnetId string = vnet.properties.subnets[0].id
output nsgId string = nsg.id
