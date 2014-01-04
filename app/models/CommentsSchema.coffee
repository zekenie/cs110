mongoose = require 'mongoose'
pagedown = require 'pagedown'
Schema = mongoose.Schema

module.exports = (dateFormatter)->
	schema = new Schema {
		user: {type:Schema.Types.ObjectId, ref:"Users"}
		comment: {type:String,get:(comment)-> pagedown.getSanitizingConverter().makeHtml comment }
	}

	schema.plugin dateFormatter.addon


	schema
