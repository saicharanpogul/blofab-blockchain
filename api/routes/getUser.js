'use strict'

const express = require('express')
const router = express.Router()
const { Wallets } = require('fabric-network')
const path = require('path')

// GET USER
router.post('/', async (req, res, next) => {
  try {
    const username = req.body.username

    const walletPath = path.join(__dirname, '../wallet')
    const wallet = await Wallets.newFileSystemWallet(walletPath)

    const identity = await wallet.get(username)

    if (!identity) {
      console.log(`An identity for the user "${username.toUpperCase()}" does not exist in the wallet.`)
      throw new Error(`An identity for the user "${username.toUpperCase()}" does not exist in the wallet.`)
    }

    // Check if the user is registered
    if (identity) {
      console.log(`${username.toUpperCase()} exist.`)
      res.status(200).json({
        status: "successful",
        message: `${username} is registered.`,
        data: true
      })
    }
  } catch (error) {
    console.log(error.message)
    res.status(500).json({
      status: "failed",
      message: error.message,
      data: false
    })
  }
})

module.exports = router