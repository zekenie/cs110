mongoose = require 'mongoose'
Schema = mongoose.Schema

module.exports = ->
	TermsSchema = new Schema { 
		name: {type:String}
		tags: [{type:Schema.Types.ObjectId, ref:"Tags"}]
		description: {type:String}
		createdAt: {type:Date}
	}
	

	

	

	

	mongoose.model 'Terms', TermsSchema