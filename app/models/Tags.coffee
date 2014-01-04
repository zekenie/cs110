mongoose = require 'mongoose'
Schema = mongoose.Schema

module.exports = (dateFormatter)->
	TagsSchema = new Schema {
		name: {type:String,unique:true}
		days: [{type:Schema.Types.ObjectId, ref:"Days"}]
		hws: [{type:Schema.Types.ObjectId, ref:"Hws"}]
		terms: [{type:Schema.Types.ObjectId, ref:"Terms"}]
		issues: [{type:Schema.Types.ObjectId, ref:"Issues"}]
	}





	TagsSchema.statics.findByName = (name,cb)->
		@findOne {name:name},cb

	TagsSchema.plugin dateFormatter.addon




	mongoose.model 'Tags', TagsSchema