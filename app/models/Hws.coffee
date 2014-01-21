mongoose = require 'mongoose'
Schema = mongoose.Schema
moment = require 'moment'

module.exports = (dateFormatter,tagHelper,mdHelper)->
	HwsSchema = new Schema {
		name: {type:String,set:(str)->str.trim()}
		description:{type:String,get:mdHelper.get}
		dateAssigned: {type:Date,get:dateFormatter.get}
		dateDue: {type:Date,get:dateFormatter.get}
		dayAssigned: {type:Schema.Types.ObjectId, ref:"Days"}
		dayDue: {type:Schema.Types.ObjectId, ref:"Days"}
		issues: [{type:Schema.Types.ObjectId, ref:"Issues"}]
		tags: [{type:Schema.Types.ObjectId, ref:"Tags"}]
		hw_submissions: [{type:Schema.Types.ObjectId, ref:"Hw_submissions"}]
		checklist: [{type:String}]
	}

	# assoc hws
	HwsSchema.pre 'save',(next)->
		console.log '************'
		console.log @
		return next() if not @isNew
		@populate 'dayAssigned dayDue', (err,hw)->
			hw.dayAssigned.hwAssigned.addToSet hw.id
			hw.dayAssigned.save()
			hw.dayDue.hwDue.addToSet hw.id
			hw.dayDue.save()
			next()

	HwsSchema.pre 'save',(next)->
		self = @
		# if the dates have been changed
		if @isModified 'dayAssigned' or @isModified 'dayDue'
			#if we've got paths populated
			if "meetingAt" in @dayAssigned and "meetingAt" in @dayDue
				@dateAssigned = @dayAssigned.meetingAt
				@dateDue = @dayDue.meetingAt
				next()
			else
				@populate 'dayAssigned dayDue',(err,hw)->
					self.dateAssigned = hw.dayAssigned.meetingAt
					self.dateDue = hw.dayDue.meetingAt
					next()
		else
			next()


	HwsSchema.methods.tag = (tags,cb)->
		tagHelper.tag.call @, tags,cb

	HwsSchema.methods.removeTag = (tag,cb)->
		tagHelper.removeTag.call @, tag,cb

	HwsSchema.methods.getCompleteStudents = (cb)->
		cb()

	HwsSchema.methods.getIncompleteStudents = (cb)->
		cb()

	HwsSchema.plugin dateFormatter.addon

	HwsSchema.virtual('timeLeft').get ->
		moment.duration(moment().diff(@dateDue)).humanize()

	HwsSchema.virtual('timeTotal').get ->
		moment.duration(moment(@dateAssigned).diff(@dateDue)).humanize()

	HwsSchema.virtual('past').get ->
		Date.now() > @dateDue





	mongoose.model 'Hws', HwsSchema