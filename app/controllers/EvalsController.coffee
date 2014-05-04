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

	controller.final = [
		instructorOrTa,
		(req,res,next)->
			res.render 'evals/final', {student: req.reqUser}
	]
	controller