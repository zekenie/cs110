mongoose = require 'mongoose'
Schema = mongoose.Schema

module.exports = ->
	UsersSchema = new Schema {
		first: {type:String}
		last: {type:String}
		role: {type:String,default:"student"}
		fbData: {type:Schema.Types.Mixed}
		hw_submissions: [{type:Schema.Types.ObjectId, ref:"Hw_submissions"}]
		issues: [{type:Schema.Types.ObjectId, ref:"Issues"}]
		email: {type:String}
		phone: {type:String}
		createdAt: {type:Date}
	}



	UsersSchema.methods.getHwSubmissions = (cb)->
		cb()



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



	UsersSchema.virtual('name').get ->
		"#{@first} #{@last}"

	UsersSchema.virtual('instructorOrTa').get ->
		@instructor or @ta

	UsersSchema.virtual('instructor').get ->
		@role is 'instructor'

	UsersSchema.virtual('ta').get ->
		@role is 'ta'

	mongoose.model 'Users', UsersSchema