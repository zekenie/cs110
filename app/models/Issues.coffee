mongoose = require 'mongoose'
pagedown = require 'pagedown'
Schema = mongoose.Schema
_ = require 'lodash'
async = require 'async'

module.exports = (CommentsSchema,commentHelper,tagHelper,dateFormatter,mdHelper,Users)->
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

	IssuesSchema.virtual('commentNotification').get ->
		"Someone has commented on the issue '#{@title}'"

	# IssuesSchema.methods.notify = (omit,cb)->
	# 	self = @
	# 	user = @user.id or @user
	# 	user = user.toString()
	# 	alreadyNotified = [user,omit.toString()]
	# 	Users.findByIdAndNotify user,@commentNotification,'Issues',@id, (err,status)->
	# 		for comment in self.comments
	# 			if not _.contains alreadyNotified, comment.user.toString()
	# 				alreadyNotified.push comment.user.toString()
	# 				Users.findByIdAndNotify comment.user.toString(),@commentNotification,'Issues',self.id
	# 		cb(err,status)

	# IssuesSchema.methods.comment = (comment,cb)->
	# 	@comments.push comment
	# 	@save (err,issue)->
	# 		return cb err if err?
	# 		issue.notify comment.user, cb


	IssuesSchema.methods.tag = (tags,cb)->
		tagHelper.tag.call @, tags,cb

	IssuesSchema.methods.removeTag = (tag,cb)->
		tagHelper.removeTag.call @, tag,cb

	IssuesSchema.plugin dateFormatter.addon
	IssuesSchema.plugin commentHelper




	mongoose.model 'Issues', IssuesSchema