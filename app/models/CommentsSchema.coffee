mongoose = require 'mongoose'
Schema = mongoose.Schema

module.exports = ->
	new Schema {
		user: {type:Schema.Types.ObjectId, ref:"Users"}
		comment: {type:String}
		createdAt: {type:Date}
	}
