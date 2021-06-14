'use strict'

const express = require('express')
const cors = require('cors')
const morgan = require('morgan')
const fs = require('fs')

// routes
const registerUserRoute = require('./routes/registerUser')
const getUserRoute = require('./routes/getUser')
const incrementBloodCountRoute = require('./routes/incrementBloodCount')
const decrementBloodCountRoute = require('./routes/decrementBloodCount')
const getBloodCountsRoute = require('./routes/getBloodCounts')
const getBloodCountHistoryRoute = require('./routes/getBloodCountHistory')

const app = express()
app.use(express.json())
app.use(cors())
require('dotenv').config()
app.use(morgan('combined'))
app.use(morgan("combined", {
    stream: fs.createWriteStream('./access.log', {flags: 'a'})
}))

// use routes
app.use('/registerUser', registerUserRoute)
app.use('/getUser', getUserRoute)
app.use('/increment', incrementBloodCountRoute)
app.use('/decrement', decrementBloodCountRoute)
app.use('/getBloodCounts', getBloodCountsRoute)
app.use('/getBloodCountHistory', getBloodCountHistoryRoute)

// TEST
app.get('/blofab', async function (req, res) {
  try {
    console.log("Test Pass!")
    res.status(200).json({ status: "successful" })
  } catch (error) {
    console.log("Test Fail!")
    res.status(400).json({ status: "failed" })
    process.exit(1)
  }
})

app.listen(7080, '0.0.0.0');
console.log('Blofab Organization API Server is running on http://localhost:7080');