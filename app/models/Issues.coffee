mongoose = require 'mongoose'
pagedown = require 'pagedown'
Schema = mongoose.Schema

module.exports = (CommentsSchema,tagHelper,dateFormatter)->
	IssuesSchema = new Schema {
		title: {type:String}
		user: {type:Schema.Types.ObjectId, ref:"Users"}
		description: {type:String,get:(str)-> pagedown.getSanitizingConverter().makeHtml str }
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
		if @hw?
			mongoose.model('Hws').findById @hw, (err,hw)->
				return console.log err if err?
				hw.issues.addToSet self.id
				hw.save (err,hw)->
					return console.log err if err?
					next()
		else if @day?
			mongoose.model('Days').findById @day, (err,day)->
				return console.log err if err?
				day.issues.addToSet self.id
				day.save (err,day)->
					return console.log err if err?
					next()
		else
			next()

	IssuesSchema.methods.tag = (tags,cb)->
		tagHelper.tag.call @, tags,cb

	IssuesSchema.methods.removeTag = (tag,cb)->
		tagHelper.removeTag.call @, tag,cb

	IssuesSchema.plugin dateFormatter.addon




	mongoose.model 'Issues', IssuesSchema