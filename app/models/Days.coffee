mongoose = require 'mongoose'
Schema = mongoose.Schema



module.exports = (tagHelper,dateFormatter)->
	DaysSchema = new Schema {
		meetingAt: {type:Date,get:dateFormatter.get,set:dateFormatter.set}
		summary: {type:String}
		links: [{type:String}]
		hwDue: [{type:Schema.Types.ObjectId, ref:"Hws"}]
		hwAssigned: [{type:Schema.Types.ObjectId, ref:"Hws"}]
		slides: {type:String}
		issues: [{type:Schema.Types.ObjectId, ref:"Issues"}]
		tags: [{type:Schema.Types.ObjectId, ref:"Tags"}]
	}


	DaysSchema.methods.tag = (tags,cb)->
		tagHelper.tag.call @, tags,cb

	DaysSchema.methods.removeTag = (tag,cb)->
		tagHelper.removeTag.call @, tag,cb

	DaysSchema.plugin dateFormatter.addon

	DaysSchema.static 'getDaysList', (query,cb)->
		@find(query).sort({meetingAt:1}).exec (err,days)->
			return cb err if err?
			arr = []
			for day in days
				arr.push {id:day.id,d:day.meetingAt}
			cb null, arr


	mongoose.model 'Days', DaysSchema