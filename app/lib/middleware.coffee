# first: {type:String}
# last: {type:String}
# role: {type:String}
# fbData: {type:Schema.Types.Mixed}
# hw_submissions: [{type:Schema.Types.ObjectId, ref:"Hw_submissions"}]
# issues: [{type:Schema.Types.ObjectId, ref:"Issues"}]
# email: {type:String}
# phone: {type:String}
# createdAt: {type:Date}

express = require "express"
mongoose = require 'mongoose'
MongoStore = require 'connect-mongodb'
passport = require 'passport'
FacebookStrategy = require('passport-facebook').Strategy
module.exports = (app,config,Users) ->
    errorConfig =
        dumpExceptions: true
        showStack: true

    mongoStore = new MongoStore {
        url:config.mongoUri
    }

    session_middleware = express.session {
        key:config.session.key
        secret:config.session.secret
        store:mongoStore
    }

    mongoose.connect config.mongoUri

    error_middleware = express.errorHandler errorConfig
    app.use express.logger()

    app.use express.static( app.get "public" )
    app.use express.cookieParser()
    app.use session_middleware
    app.use express.bodyParser()
    app.use express.methodOverride()

    app.use passport.initialize()

    app.use passport.session()

    app.use app.router
    app.use (req, res, next) ->
        res.send 404
    app.use error_middleware


    passport.use new FacebookStrategy {
        clientID:config.fb.clientId
        clientSecret:config.fb.clientSecret
        callbackURL:config.fb.callbackUrl
        profileFields:['id','displayName','photos','username','name']
    }, (accessToken, refreshToken, profile, done)->
        Users.findOne {'fbData.id':profile.id}, (err,user)->
            return done err if err?
            return done null, user if user?
            Users.create {
                first: profile.name.givenName
                last: profile.name.familyName
                role: 'student'
                fbData:profile._json
                createdAt: new Date()
            },(err,user)->
                return done err if err?
                done null, user

    passport.serializeUser (user,done)->
        done null,user.id

    passport.deserializeUser (id,done)->
        Users.findById id, (err,user)->
            return done err if err?
            done null,user


