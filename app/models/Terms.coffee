mongoose = require 'mongoose'
Schema = mongoose.Schema

module.exports = (dateFormatter)->
	TermsSchema = new Schema {
		name: {type:String}
		tags: [{type:Schema.Types.ObjectId, ref:"Tags"}]
		description: {type:String}
	}



	TermsSchema.plugin dateFormatter.addon





	mongoose.model 'Terms', TermsSchema