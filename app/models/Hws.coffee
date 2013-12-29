mongoose = require 'mongoose'
Schema = mongoose.Schema

module.exports = ->
	HwsSchema = new Schema { 
		name: {type:String}
		dateAssigned: {type:Date}
		dateDue: {type:Date}
		createdAt: {type:Date}
		dayAssigned: {type:Schema.Types.ObjectId, ref:"Days"}
		dayDue: {type:Schema.Types.ObjectId, ref:"Days"}
		issues: [{type:Schema.Types.ObjectId, ref:"Issues"}]
		tags: [{type:Schema.Types.ObjectId, ref:"Tags"}]
		hw_submissions: [{type:Schema.Types.ObjectId, ref:"Hw_submissions"}]
		checklist: [{type:String}]
	}
	

	
	HwsSchema.methods.getCompleteStudents = (cb)->
		cb()
	
	HwsSchema.methods.getIncompleteStudents = (cb)->
		cb()
	

	

	
	HwsSchema.virtual('timeLeft').get ->
		# Document can be accessed through `this`
	
	HwsSchema.virtual('timeTotal').get ->
		# Document can be accessed through `this`
	

	mongoose.model 'Hws', HwsSchema