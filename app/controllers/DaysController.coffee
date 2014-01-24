_ = require 'lodash'
mongoose = require 'mongoose'

module.exports = (app,config,Days)->
	controller = {}
	controller.load = (req,res,next,id)->
		Days.findById(id).populate("hwAssigned hwDue tags").exec (err,day)->
			return next err if err?
			return res.send 404 if not day?
			req.day = day
			next()

	countStudents = (req,res,next)->
		mongoose.model('Users').count {role:'student'}, (err,studentCount)->
			return next err if err?
			app.locals.studentCount = studentCount
			next()

	controller.index = [
		countStudents
		(req,res,next)->
			Days.find({}).sort('meetingAt').populate('hwDue hwAssigned issues tags').exec (err,days)->

				res.render "days/index",{days:days}
	]

	controller.delete = [
		(req,res,next)->
			return res.send 400, 'you can\'t do that with your account role' if req.user.student
			req.day.remove (err)->
				return next err if err?
				res.send 200
	]

	controller.new = [
		(req,res,next)->
			res.render "days/new"
	]

	formProcess = (req,res,next)->
		return res.send 400, 'you can\'t do that with your account role' if req.user.student
		req.body.links = _.compact req.body.links.split "\r\n"
		req.tags = req.body.tags.split ','
		delete req.body.tags
		next()

	controller.edit = [
		(req,res,next)->
			return res.send 400, 'you can\'t do that with your account role' if req.user.student

		(req,res,next)->
			res.render 'days/edit', {day:req.day}
	]

	controller.view = [
		countStudents
		(req,res,next)->
			res.render 'days/view', {day:req.day}
	]

	controller.update = [
		formProcess,
		(req,res,next)->
			for k,v of req.body
				req.day[k] = v
			req.day.tag req.tags, (err,day)->
				return next err if err?
				day.save (err,day)->
					return next err if err?
					res.redirect '/days/' + day.id
	]

	controller.create = [
		formProcess,
		(req,res,next)->
			# return console.log req.body
			day = new Days req.body
			day.tag req.tags, (err,day)->
				return next err if err?
				day.save (err,day)->
					return next err if err?
					res.redirect '/'
	]

	controller