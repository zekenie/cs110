mongoose = require 'mongoose'
Schema = mongoose.Schema

module.exports = ->
	TagsSchema = new Schema {
		name: {type:String}
		days: [{type:Schema.Types.ObjectId, ref:"Days"}]
		hws: [{type:Schema.Types.ObjectId, ref:"Hws"}]
		terms: [{type:Schema.Types.ObjectId, ref:"Terms"}]
		issues: [{type:Schema.Types.ObjectId, ref:"Issues"}]
		createdAt: {type:Date}
	}





	TagsSchema.statics.getByName = (name,cb)->
		@findOne {name:name},cb




	mongoose.model 'Tags', TagsSchema