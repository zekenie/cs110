mongoose = require 'mongoose'
Schema = mongoose.Schema

module.exports = (dateFormatter,config)->

	NotificationsBlacklistsSchema = new Schema {
		table:String
		foreignId:{type:Schema.Types.ObjectId}
		user:{type:Schema.Types.ObjectId,ref:"Users"}
	}

	NotificationsBlacklistsSchema.methods.findOrCreate = (obj,cb)->
		self = @
		@findOne obj, (err,notificationBlacklist)->
			return cb err if err?
			return cb null, notificationBlacklist if notificationBlacklist?
			self.create obj, cb


	mongoose.model 'NotificationBlacklists', NotificationsBlacklistsSchema