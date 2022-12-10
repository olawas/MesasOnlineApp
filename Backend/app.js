var dotenv = require('dotenv')
dotenv.config()
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var cors = require('cors')
var mongodb = require('./mongo/mongo.js');
const router = require('./routes/index')
const routerLogin = require('./routes/login')

mongodb()

var app = express()

app.use(cors())
app.use(logger('dev'))
app.use(express.json())
app.use(express.urlencoded({ extended: false }))
app.use(cookieParser())
app.use(express.static(path.join(__dirname, 'public')))

app.use('/login', routerLogin)
app.use('/mongo', router)
module.exports = app