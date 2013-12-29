mongoose = require 'mongoose'
Schema = mongoose.Schema

module.exports = ->
	Hw_submissionsSchema = new Schema { 
		user: {type:Schema.Types.ObjectId, ref:"Users"}
		hw: {type:Schema.Types.ObjectId, ref:"Hws"}
		createdAt: {type:Date}
		comments: {type:Array}
		checklist: {type:Array}
	}
	

	
	Hw_submissionsSchema.methods.issuesByUser = (cb)->
		cb()
	

	

	

	mongoose.model 'Hw_submissions', Hw_submissionsSchema