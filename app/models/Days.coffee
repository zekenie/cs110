mongoose = require 'mongoose'
Schema = mongoose.Schema

module.exports = (tagHelper)->
	DaysSchema = new Schema {
		meetingAt: {type:Date}
		summary: {type:String}
		links: [{type:String}]
		hwDue: [{type:Schema.Types.ObjectId, ref:"Hws"}]
		hwAssigned: [{type:Schema.Types.ObjectId, ref:"Hws"}]
		slides: {type:String}
		issues: [{type:Schema.Types.ObjectId, ref:"Issues"}]
		tags: [{type:Schema.Types.ObjectId, ref:"Tags"}]
		createdAt: {type:Date}
	}


	DaysSchema.methods.tag = (tags,cb)->
		tagHelper.tag.call @, tags,cb

	DaysSchema.methods.removeTag = (tag,cb)->
		tagHelper.removeTag.call @, tag,cb


	mongoose.model 'Days', DaysSchema