mongoose = require 'mongoose'
Schema = mongoose.Schema

module.exports = (dateFormatter)->
	Hw_submissionsSchema = new Schema {
		user: {type:Schema.Types.ObjectId, ref:"Users"}
		hw: {type:Schema.Types.ObjectId, ref:"Hws"}
		comments: {type:Array}
		checklist: {type:Array}
	}



	Hw_submissionsSchema.methods.issuesByUser = (cb)->
		cb()

	Hw_submissionsSchema.plugin dateFormatter.addon





	mongoose.model 'Hw_submissions', Hw_submissionsSchema