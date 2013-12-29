mongoose = require 'mongoose'
Schema = mongoose.Schema

module.exports = ->
	IssuesSchema = new Schema { 
		title: {type:String}
		user: {type:Schema.Types.ObjectId, ref:"Users"}
		description: {type:String}
		day: {type:Schema.Types.ObjectId, ref:"Days"}
		hw: {type:Schema.Types.ObjectId, ref:"Hws"}
		tags: [{type:Schema.Types.ObjectId, ref:"Tags"}]
		open: {type:Boolean}
		assignedTo: {type:Schema.Types.ObjectId, ref:"Users"}
	}
	

	

	

	

	mongoose.model 'Issues', IssuesSchema