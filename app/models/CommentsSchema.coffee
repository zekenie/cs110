mongoose = require 'mongoose'
Schema = mongoose.Schema

module.exports = (dateFormatter,mdHelper)->
	schema = new Schema {
		user: {type:Schema.Types.ObjectId, ref:"Users"}
		comment: {type:String,get:mdHelper.get }
	}

	schema.plugin dateFormatter.addon


	schema
