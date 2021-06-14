const FabricCAServices = require('fabric-ca-client')
const { Wallets } = require('fabric-network')
const fs = require('fs')
const path = require('path')

async function main() {

  const adminName = "blofab"
  const adminPass = "adminpw"

  try {
      // load the network configuration
      const ccpPath = path.resolve(__dirname, 'connection-profile.json')
      const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf-8'))

      // Create a new CA Client for interacting with the CA.
      const caInfo = ccp.certificateAuthorities['ca.blofab.example.com']
      const caTLSCACerts = caInfo.tlsCACerts.pem
      const ca = new FabricCAServices(caInfo.url, { trustedRoots: caTLSCACerts, verify: false }, caInfo.caName)

      // Create a new file system based wallet for managing identities.
      const walletPath = path.join(process.cwd(), 'wallet')
      const wallet = await Wallets.newFileSystemWallet(walletPath)
      console.log(`Wallet path: ${walletPath}`)

      // Check to see if we've already enrolled the admin user.
      const identity = await wallet.get(adminName)
      if (identity) {
          console.log(`An identity for the admin user "${adminName}" already exists in the wallet`)
          return
      }

      // Enroll the admin user, and import the new identity init the wallet.
      const enrollment = await ca.enroll({ enrollmentID: adminName, enrollmentSecret: adminPass })
      const x509Identity = {
          credentials: {
              certificate: enrollment.certificate,
              privateKey: enrollment.key.toBytes(),
          },
          mspId: 'BlofabMSP',
          type: 'X.509',
      }
      await wallet.put(adminName, x509Identity)
      console.log(`Successfully enrolled admin user "${adminName}" and imported it into the wallet`)
  } catch (error) {
      console.error(`Failed to enroll admin user "${adminName}": ${error}`)
      process.exit(1)
  }
}

main()