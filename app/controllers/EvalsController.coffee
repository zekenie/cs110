mongoose = require 'mongoose'
ObjectId = mongoose.Types.ObjectId
module.exports = (app,config)->
	controller = {}

	instructorOrTa = (req,res,next)->
		return res.send 400 unless req.user.instructorOrTa
		next()

	# this route lists all students assigned to user
	controller.index = [
		instructorOrTa,
		(req,res,next)->
			mongoose.model('Users').find({role:'ta'}).populate('assigned_students').exec (err,TAs)->
				res.render 'evals/index', {TAs:TAs}
	]

	controller.update = [
		instructorOrTa,
		(req,res,next)->
			for key in ['html','css','javascript','taSessions','final']
				req.reqUser.eval[key] = req.body[key] if req.body[key]?
			req.reqUser.save (err,user)->
				return next err if err?
				req.flash 'Eval updated'
				res.redirect "/evals"
	]

	controller.skills = [
		instructorOrTa,
		(req,res,next)->
			mongoose.model('Users').studentsWithHw {_id:req.reqUser._id}, (err,studentsAndHw)->
				return next err if err?
				res.render "evals/skills", {
					student:req.reqUser,
					hwHistory:{
						students:JSON.stringify(studentsAndHw.students),
						hws:JSON.stringify(studentsAndHw.hws)
					}
				}
	]


	controller.final = [
		instructorOrTa,
		(req,res,next)->
			finalProject = mongoose.model('Hw_submissions').findOne {
				hw: new ObjectId("535e442396983802000d8270") # not a great thing to do...
				user:req.reqUser._id
			}, (err,final) ->
				return next err if err?
				console.log 'final',final
				res.render 'evals/final', {student: req.reqUser,final:final}
	]

	controller