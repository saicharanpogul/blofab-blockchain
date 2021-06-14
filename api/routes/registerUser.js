'use strict'

const express = require('express')
const router = express.Router()
const { registerEnroll } = require('../register&enrollUser')

// REGISTER USERS
router.post('/', async (req, res, next) => {
  try {
    const err = await registerEnroll(req.body.username)
    if (err) {
      throw new Error(err)
    }

    res.status(201).json({
      status: "successful",
      message: `Successfully registered & enrolled user ${req.body.username.toUpperCase()} and imported into the wallet`,
      data: true
    })
  } catch (error) {
    res.status(501).json({
      status: "failed",
      message: `Failed to register and enroll user ${req.body.username.toUpperCase()}: ${error.message}`,
      data: false
    })
  }
})

module.exports = router