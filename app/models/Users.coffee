mongoose = require 'mongoose'
Schema = mongoose.Schema

module.exports = ->
	UsersSchema = new Schema { 
		first: {type:String}
		last: {type:String}
		role: {type:String}
		fbData: {type:Schema.Types.Mixed}
		hw_submissions: [{type:Schema.Types.ObjectId, ref:"Hw_submissions"}]
		issues: [{type:Schema.Types.ObjectId, ref:"Issues"}]
		email: {type:String}
		phone: {type:String}
		createdAt: {type:Date}
	}
	

	
	UsersSchema.methods.getHwSubmissions = (cb)->
		cb()
	

	
	UsersSchema.statics.getList = (cb)->
		cb()
	

	
	UsersSchema.virtual('name').get ->
		# Document can be accessed through `this`
	

	mongoose.model 'Users', UsersSchema