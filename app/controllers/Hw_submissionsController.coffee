module.exports = (Hw_submissions)->
	controller = {}
	controller.load = (req,res,next,id)->
		Hw_submissions.findById(id).populate('user hw').exec (err,hw_submission)->
			return next err if err?
			return res.send 404 if not hw_submission?
			req.user.mine = req.user.equals hw_submission.user
			req.hw_submission = hw_submission
			next

	controller.view = (req,res,next)->
		res.render 'hws_submissions/view', {hw_submission:req.hw_submission}

	controller.comment = []

	controller