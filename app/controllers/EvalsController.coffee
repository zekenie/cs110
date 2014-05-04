mongoose = require 'mongoose'
module.exports = (app,config)->
	controller = {}

	instructorOrTa = (req,res,next)->
		return res.send 400 unless req.user.instructorOrTa
		next()

	# this route lists all students assigned to user
	controller.index = [
		instructorOrTa,
		(req,res,next)->
			if req.user.ta
				req.user.populate 'assigned_students', (err,user)->
					res.render 'evals/index', {students:user.assigned_students}
			else
				mongoose.model('Users').find({role:'ta'}).populate('assigned_students').exec (err,TAs)->
					res.render 'evals/instructorIndex', {TAs:TAs}
	]

	controller.final = {
		edit: [
			instructorOrTa,
			(req,res,next)->
				finalProject = mongoose.model('Hw_submissions').find {
					hw:{$oid:"535e442396983802000d8270"} # not a great thing to do...
					user:req.reqUser._id
				}, (err,final) ->
					return next err if err?
					res.render 'evals/final', {student: req.reqUser,final:final}
		]
		update: [
			instructorOrTa,
			(req,res,next)->
				req.reqUser.eval.final = req.body.final
				req.reqUser.save (err,user)->
					return next err if err?
					req.flash "Eval updated"
					res.redirect "/evals/#{user.id}/final"
		]
	}
	controller