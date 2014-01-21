mongoose = require 'mongoose'
jsdiff = require 'diff'
Schema = mongoose.Schema

module.exports = (dateFormatter,tagHelper)->

	ContributionsScema = new Schema {
		user: {type:Schema.Types.ObjectId, ref:"Users"}
		diff:[]
	}

	TermsSchema = new Schema {
		name: {type:String,set:(str)->str.trim()}
		tags: [{type:Schema.Types.ObjectId, ref:"Tags"}]
		description: {type:String}
		contributions:[ContributionsScema]
	}

	TermsSchema.methods.changeDescription = (user,change)->
		diff = jsdiff.diffChars @description, change
		@description = change
		@contributions.push {
			user: user.id or user
			diff:diff
		}
		@

	TermsSchema.statics.search = (q,cb)->
		query = {}
		query.name = new RegExp q,'i' if q?
		@find query, cb

	TermsSchema.methods.tag = (tags,cb)->
		tagHelper.tag.call @, tags,cb

	TermsSchema.methods.removeTag = (tag,cb)->
		tagHelper.removeTag.call @, tag,cb

	TermsSchema.plugin dateFormatter.addon
	ContributionsScema.plugin dateFormatter.addon


	mongoose.model 'Terms', TermsSchema