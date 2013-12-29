express = require "express"
mongoose = require 'mongoose'
module.exports = (app,config) ->
    errorConfig =
        dumpExceptions: true
        showStack: true
    mongoose.set 'debug', true

    mongoose.connect config.mongoUri

    error_middleware = express.errorHandler errorConfig
    app.use express.logger()

    app.use express.static( app.get "public" )
    app.use express.cookieParser()
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use app.router
    app.use (req, res, next) ->
        res.send 404
    app.use error_middleware