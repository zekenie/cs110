mongoose = require 'mongoose'
pagedown = require 'pagedown'
Schema = mongoose.Schema
_ = require 'lodash'
async = require 'async'

module.exports = (CommentsSchema,tagHelper,dateFormatter,mdHelper,Users)->
	IssuesSchema = new Schema {
		title: {type:String}
		user: {type:Schema.Types.ObjectId, ref:"Users"}
		description: {type:String,get:mdHelper.get }
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
			Hws:'hw'
			Days:'day'
			Users:'user'
		}

		for plural,singular of relations
			if @[singular]?
				mongoose.model(plural).findById @[singular], (err,doc)->
					return console.log err if err?
					doc.issues.addToSet self.id
					doc.save()

		next()

	IssuesSchema.methods.notify = (omit,cb)->
		self = @
		toNotify = [@user.id or @user.toString()]
		omit = omit.toString()
		for comment in @comments
			toNotify.push comment.user.id.toString() or comment.user.toString()
		# console.log omit
		# toNotify = _.uniq toNotify
		# console.log toNotify
		# toNotify = _.without omit if omit?
		console.log toNotify
		toRun = []
		for id in toNotify
			console.log id
			toRun.push (callback)->
				Users.findByIdAndNotify id, "Someone has commented on '#{self.title}'","Issues",self.id,callback
		async.series toRun, cb

	IssuesSchema.methods.tag = (tags,cb)->
		tagHelper.tag.call @, tags,cb

	IssuesSchema.methods.removeTag = (tag,cb)->
		tagHelper.removeTag.call @, tag,cb

	IssuesSchema.plugin dateFormatter.addon




	mongoose.model 'Issues', IssuesSchema