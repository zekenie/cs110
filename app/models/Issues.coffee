mongoose = require 'mongoose'
Schema = mongoose.Schema

module.exports = (CommentsSchema)->
	IssuesSchema = new Schema {
		title: {type:String}
		user: {type:Schema.Types.ObjectId, ref:"Users"}
		description: {type:String}
		createdAt:{type:Date}
		day: {type:Schema.Types.ObjectId, ref:"Days"}
		hw: {type:Schema.Types.ObjectId, ref:"Hws"}
		tags: [{type:Schema.Types.ObjectId, ref:"Tags"}]
		open: {type:Boolean,default:true}
		assignedTo: {type:Schema.Types.ObjectId, ref:"Users"}
		comments:[CommentsSchema]
	}

	IssuesSchema.methods.tag = (tags,cb)->
		tagHelper.tag.call @, tags,cb

	IssuesSchema.methods.removeTag = (tag,cb)->
		tagHelper.removeTag.call @, tag,cb






	mongoose.model 'Issues', IssuesSchema