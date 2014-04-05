mongoose = require 'mongoose'
Schema = mongoose.Schema
async = require 'async'
_ = require 'lodash'

module.exports = (dateFormatter,config,NotificationBlacklists)->
	twilio = require('twilio') config.twilio.sid, config.twilio.authToken
	postmark = require('postmark') config.postmark

	NotificationsSchema = new Schema {
		text:String
		seen:{type:Boolean,default:false}
		seenAt:Date
		path:String
		createdAt:{type:Date,get:dateFormatter.get}
	}

	SessionsSchema = new Schema {
		userAgent:{}
		ip:String
	}

	UsersSchema = new Schema {
		first: {type:String}
		last: {type:String}
		role: {type:String,default:"student"}
		fbData: {type:Schema.Types.Mixed}
		hw_submissions: [{type:Schema.Types.ObjectId, ref:"Hw_submissions"}]
		issues: [{type:Schema.Types.ObjectId, ref:"Issues"}]
		issueContributions: [{type:Schema.Types.ObjectId, ref:"Issues"}]
		assigned_students: [{type:Schema.Types.ObjectId, ref:"Users"}]
		email: {type:String}
		phone: {type:String}
		notifications:[NotificationsSchema]
	}

	UsersSchema.virtual('unreadNotifications').get ->
		@notifications.filter (notification)->
			not notification.seen

	UsersSchema.methods.newestNotifications = (n,cb)->
        cb @notifications.reverse().splice(0,n)

	UsersSchema.methods.sms = (msg,cb)->
		return cb null, {message:'No phone number'} unless @phone?
		twilio.sendMessage {
			to:@phone
			from:config.twilio.phone,
			body: msg
		}, cb

	UsersSchema.methods.sendEmail = (subject,msg,cb)->
		return cb null, {message:'No email'} unless @email?
		postmark.send {
			From:"zanCS@hampshire.edu"
			To:@email
			Subject:subject
			TextBody:msg
		}, cb

	UsersSchema.statics.studentsWithHw = (query={},cb)->
		self = @
		mongoose.model('Hws').find({},"name").sort({dateDue:-1}).exec  (err,hws)->
			return cb err if err?
			self.find(_.extend({role:"student"},query),"first last fbData hw_submissions").populate({path:'hw_submissions',select:'complete'}).exec (err,students)->
				return cb err if err?
				cb null,{students:students,hws:hws}

	UsersSchema.statics.getAssignedStudentsHw = (cb)->
		self = @
		mongoose.model('Hws').find({},"name").sort({dateDue:-1}).exec  (err,hws)->
			return cb err if err?
			self.find({role:"student"},"first last fbData hw_submissions").populate('hw_submissions').exec (err,students)->
				return cb err if err?
				cb null,{students:students,hws:hws}


	UsersSchema.methods.allHws = (cb)->
		self = @
		mongoose.model('Hws').find({},"name").sort({dateDue:-1}).exec  (err,hws)->
			return cb err if err?
			mongoose.model('Hw_submissions').find {user:self.id},(err,subs)->
				return cb err if err?
				for hw in hws
					hw.submission = _.findWhere(subs, {hw:hw._id})
				cb null,hws

	UsersSchema.methods.notify = (text,table,id,cb)->
		if not cb?
			cb = -> console.log '**********************'
		path = "#{table}/#{id}"
		self = @
		NotificationBlacklists.findOne {
			user:@id,
			table:table,
			foreignId:id
		}, (err,notificationBlacklist) ->
			return cb err if err?
			return cb null, {message:'User on blacklist'} if notificationBlacklist?
			self.notifications = [] unless self.notifications?
			self.notifications.push {
				text:text
				createdAt:new Date()
				path:path
			}
			self.save (err,user)->
				return cb err if err?
				user.sms text, (err,twilioStatus)->
					return cb err if err?
					user.sendEmail "CS110 Notification", text + "\n" + path, (err,emailStatus)->
						cb err, {email:emailStatus, twilio:twilioStatus, user:user}

	UsersSchema.statics.notifyMany = (query,text,table,id,cb)->
		notificationWrappers = []
		@find query, (err,users)->
			return cb err if err?
			return cb null,{message:'no records found'} unless users?
			cb err,users
			_.invoke users,'notify',text,table,id

	UsersSchema.statics.notifyByIds = (ids,text,table,id,cb)->
		ids = ids.map (_id) -> _id.toString()
		ids = _.uniq ids
		notificationWrappers = []
		@notifyMany {'_id':{$in:ids}},text,table,id,cb

	UsersSchema.statics.random = (cb)->
		self = @
		@count {}, (err,num)->
			num = Math.floor(Math.random()*num)
			self.findOne({}).skip(num).exec cb

	UsersSchema.methods.viewNotifications = (cb)->
		for notification in @notifications
			notification.seen = true
		@save cb


	UsersSchema.methods.getHwSubmissions = (cb)->
		cb()

	UsersSchema.methods.getSubmissionForHw = (hw,cb)->
		mongoose.model('Hw_submissions').findOne {hw:hw,user:@id}, cb



	UsersSchema.statics.getList = (query,cb)->
		query = query or {}
		hash = {}
		@find query,(err,users)->
			return cb err if err?
			for user in users
				hash[user.id] = user.name
			cb(null,hash);

	UsersSchema.statics.getListByRole = (role,cb)->
		@getList {role:role},cb

	UsersSchema.pre 'remove', (next)->
		removeQuery = {user:@_id}
		mongoose.model('Hw_submissions').remove removeQuery, (err)->
			return next err if err?
			mongoose.model('Issues').remove removeQuery, (err)->
				return next err if err?
				next()


	UsersSchema.virtual('name').get ->
		"#{@first} #{@last}"

	UsersSchema.virtual('instructorOrTa').get ->
		@instructor or @ta

	UsersSchema.virtual('instructor').get ->
		@role is 'instructor'

	UsersSchema.virtual('student').get ->
		@role is 'student'

	UsersSchema.virtual('ta').get ->
		@role is 'ta'

	UsersSchema.plugin dateFormatter.addon
	SessionsSchema.plugin dateFormatter.addon

	mongoose.model 'Users', UsersSchema
