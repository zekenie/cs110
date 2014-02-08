module.exports = (Hw_submissions)->
	controller = {}
	controller.load = (req,res,next,id)->
		Hw_submissions.findById(id).populate('user hw comments.user').exec (err,hw_submission)->
			return next err if err?
			return res.send 404 if not hw_submission?
			req.user.mine = req.user.equals hw_submission.user
			req.hw_submission = hw_submission
			next()

	controller.view = (req,res,next)->
		res.render 'hw_submissions/view', {hw_submission:req.hw_submission}

	controller.comment = [
		(req,res,next)->
			req.body.user = req.user._id
			req.hw_submission.comment req.body, (err,notificationRes)->
				return next err if err?
				res.redirect "/hw_submissions/#{req.hw_submission.id}"
	]

	controller.update = [
		(req,res,next)->
			for k,v of req.body
				req.hw_submission[k] = v
			req.hw_submission.save (err,hw_submission)->
				return next err if err?
				res.json hw_submission
	]

	controller