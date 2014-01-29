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
		str = "Someone has commented on '#{@title}'"
		user = @user.id or @user
		user = user.toString()
		alreadyNotified = [user,omit.toString()]
		# idOrDoc,text,table,id,cb
		Users.findByIdAndNotify user,str,'Issues',@id, (err,status)->
			for comment in self.comments
				if not _.contains alreadyNotified, comment.user.toString()
					alreadyNotified.push comment.user.toString()
					Users.findByIdAndNotify comment.user.toString(),str,'Issues',self.id
			cb(err,status)


	IssuesSchema.methods.tag = (tags,cb)->
		tagHelper.tag.call @, tags,cb

	IssuesSchema.methods.removeTag = (tag,cb)->
		tagHelper.removeTag.call @, tag,cb

	IssuesSchema.plugin dateFormatter.addon




	mongoose.model 'Issues', IssuesSchema