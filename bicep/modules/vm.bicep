// Linux VM — Azure equivalent of your HP t630 thin client
// Ubuntu 24.04 LTS, B1s (1 vCPU, 1GB RAM) — free tier eligible
// SSH key auth only — no password (matches your homelab security posture)

param location string
param prefix string
param adminUsername string
@secure()
param adminSshPublicKey string
param subnetId string
param nsgId string

// Public IP — equivalent to your router's WAN IP / DynDNS entry
resource publicIp 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: '${prefix}-vm-pip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    dnsSettings: {
      // Gives you a stable FQDN: homelab-vm.<region>.cloudapp.azure.com
      domainNameLabel: '${prefix}-vm'
    }
  }
}

// Network Interface Card
resource nic 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: '${prefix}-vm-nic'
  location: location
  properties: {
    networkSecurityGroup: {
      id: nsgId
    }
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          // Static private IP — equivalent to your DHCP reservation for the t630
          privateIPAllocationMethod: 'Static'
          privateIPAddress: '10.0.1.10'
          subnet: {
            id: subnetId
          }
          publicIPAddress: {
            id: publicIp.id
          }
        }
      }
    ]
  }
}

// The VM itself
resource vm 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: '${prefix}-vm'
  location: location
  properties: {
    hardwareProfile: {
      // B1s: 1 vCPU, 1GB RAM — free tier eligible, sufficient for DNS + WireGuard
      vmSize: 'Standard_B1s'
    }
    storageProfile: {
      imageReference: {
        // Ubuntu 24.04 LTS — matches your homelab OS
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-noble'
        sku: '24_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
        deleteOption: 'Delete'
      }
    }
    osProfile: {
      computerName: '${prefix}-vm'
      adminUsername: adminUsername
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: adminSshPublicKey
            }
          ]
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

output publicIp string = publicIp.properties.ipAddress
output privateIp string = nic.properties.ipConfigurations[0].properties.privateIPAddress
output fqdn string = publicIp.properties.dnsSettings.fqdn
