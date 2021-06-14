'use strict'

const express = require('express')
const router = express.Router()
const { Gateway, Wallets } = require('fabric-network')
const path = require('path')
const fs = require('fs')

// Increment Blood Count by blood type
router.put('/', async (req, res, next) => {
  try {
    const username = req.body.username
    // Load the network configuration.
    const ccpPath = path.resolve(__dirname, '../connection-profile.json')
    const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf-8'))

    // Create a new file system based wallet for managing identities.
    const wallerPath = path.join(__dirname, '../wallet')
    const wallet = await Wallets.newFileSystemWallet(wallerPath)
    console.log(`Wallet Path: ${wallerPath}`)

    // Check to see if we've already enrolled the user.
    const identity = await wallet.get(username)
    if (!identity) {
      console.log(`An identity for the user "${username}" does not exist in the wallet`)
      // console.log('Run the registerUser.js application before retrying')
      throw new Error(`An identity for the user ${username.toUpperCase()} does not exist in the wallet`)
    }

    // Create a new gateway for connecting to our peer node.
    const gateway = new Gateway()
    await gateway.connect(ccp, {
      wallet,
      identity: username,
      discovery: {
        enabled: true,
        asLocalhost: false
      }
    })

    // Get the network (channel) our contract is deployed to.
    const network = await gateway.getNetwork(process.env.CHANNEL_NAME)

    // Get the contract from the network.
    const contract = network.getContract(process.env.CHAINCODE_NAME)

    // DecrementBloodCount(ctx contractapi.TransactionContextInterface, bloodBankId string, bloodType string)
    const result = await contract.submitTransaction(
      'DecrementBloodCount',
      req.body.bloodBankId,
      req.body.bloodType
    )

    console.log('Decrement transaction has been submitted.')
    res.status(201).json({
      status: "successful",
      message: "Decrement transaction has been submitted.",
      data: JSON.parse(result.toString())
    })

    // Disconnect from the gateway.
    await gateway.disconnect()
  } catch (error) {
    console.log(`Failed to evaluate decrement transaction: ${error.message}`)
    res.status(400).json({
      status: "failed",
      message: error.message,
      data: null
    })
  }
})

module.exports = router