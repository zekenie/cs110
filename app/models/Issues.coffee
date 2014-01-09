mongoose = require 'mongoose'
pagedown = require 'pagedown'
Schema = mongoose.Schema

module.exports = (CommentsSchema,tagHelper,dateFormatter,mdHelper)->
	IssuesSchema = new Schema {
		title: {type:String}
		user: {type:Schema.Types.ObjectId, ref:"Users"}
		description: {type:String,mdHelper.get }
		closedAt:{type:Date,get:dateFormatter.get}
		day: {type:Schema.Types.ObjectId, ref:"Days"}
		hw: {type:Schema.Types.ObjectId, ref:"Hws"}
		tags: [{type:Schema.Types.ObjectId, ref:"Tags"}]
		open: {type:Boolean,default:true}
		assignedTo: {type:Schema.Types.ObjectId, ref:"Users"}
		comments:[CommentsSchema]
	}

	IssuesSchema.pre 'save', (next)->
		self = @

		relations = {
			hws:'hw'
			days:'day'
			users:'user'
		}

		for plural,singular of relations
			if @[singular]?
				mongoose.model(plural).findById @[singular], (err,doc)->
					return console.log err if err?
					doc.issues.addToSet self.id
					doc.save()

		next()

	IssuesSchema.methods.tag = (tags,cb)->
		tagHelper.tag.call @, tags,cb

	IssuesSchema.methods.removeTag = (tag,cb)->
		tagHelper.removeTag.call @, tag,cb

	IssuesSchema.plugin dateFormatter.addon




	mongoose.model 'Issues', IssuesSchema