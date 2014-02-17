_ = require 'lodash'
mongoose = require 'mongoose'
module.exports = (app,config,Users,Hws,Hw_submissions,Days,Issues,dateFormatter,tagHelper)->
	controller = {}

	hwTransform = (hw)->
		hw.dateAssigned = dateFormatter.get hw.dateAssigned
		hw.dateDue = dateFormatter.get hw.dateDue
		hw

	controller.load = (req,res,next,id)->
		Hws.findById(id).populate('tags hw_submissions').populate({path:"issues",options:{sort:"open"}}).exec (err,hw)->
			return next err if err?
			return res.send 404 if not hw?
			hw = hw.toObject {virtuals:true,getters:true}
			# populate the tags of issues
			tagHelper.deepPopulate "Issues","issue",hw, (err,hw)->
				return next err if err?
				req.hw = hw
				next()

	controller.index = [
		(req,res,next)->
			Hws.find({}).populate('tags').sort('dateDue').exec (err,hws)->
				return next err if err?
				hws = hws.map hwTransform
				res.render "hws/index",{hws:hws}

	]

	controller.new = [
		(req,res,next)->
			return next() if req.user.instructor
			res.send 400, 'You\'re not authorized to make homework assignments'
		(req,res,next)->
			Days.getDaysList {}, (err,daysHash)->
				res.render "hws/new",{daysHash:daysHash}
	]

	controller.submit = [
		(req,res,next)->
			req.body.user = req.user._id
			req.body.hw = req.hw._id
			Hw_submissions.create req.body, (err,hw_submission)->
				return next err if err?
				res.redirect "/hws/#{req.hw._id}"

	]

	controller.create = [
		(req,res,next)->
			req.body.checklist = req.body.checklist.split "\r\n"
			req.tags = req.body.tags.split ','
			delete req.body.tags
			next()
		(req,res,next)->
			hw = new Hws req.body
			hw.tag req.tags, (err,hw)->
				return next err if err?
				hw.save (err,hw)->
					return next err if err?
					res.redirect '/hws'
	]

	controller.view = [
		(req,res,next)->
			req.user.getSubmissionForHw req.hw._id, (err,submission)->
				return next err if err?
				req.user.submission = submission
				return next() if req.user.student
				Users.find {role:'student'}, (err,students)->
					return next err if err?
					students = students.map (student)->
						student = student.toObject {virtuals:true}
						student.submission = _.find req.hw.hw_submissions, (submission)->
							submission.user.toString() is student._id.toString()
						student
					req.hw.students = students
					next()

		(req,res,next)->
			res.render "hws/view",req.hw

	]

	controller.update = [
		(req,res,next)->
			req.hw = _.extend req.hw,req.body
			req.hw.save (err,hw)->
				return next err if err?
				res.json hw
	]

	controller