async = require 'async'
module.exports = (app,config,Days)->
	controller = {}
	controller.load = (req,res,next,id)->
		Days.findById id, (err,day)->
			return next err if err?
			return res.send 404 if not day?
			req.day = day
			next()

	controller.index = [
		((req,res,next)->
			Days.find({}).sort('meetingAt').populate('hwDue hwAssigned issues tags').exec (err,days)->
				days = days.map (day)-> day.toObject()
				res.render "days/index",{days:JSON.stringify(days)}

		)
	]

	controller.new = [
		((req,res,next)->
			res.render "days/new"

		)
	]

	controller.create = [
		#transform req.body
		((req,res,next)->
			req.body.links = req.body.links.split "\r\n"
			req.body.meetingAt = new Date req.body.meetingAt
			req.tags = req.body.tags.split ','
			delete req.body.tags
			next()
		),
		((req,res,next)->
			# return console.log req.body
			day = new Days req.body
			day.tag req.tags, (err,day)->
				return next err if err?
				day.save (err,day)->
					return next err if err?
					res.json day
		)
	]

	controller