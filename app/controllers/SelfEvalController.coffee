module.exports = (app,config)->
	controller = {}

	controller.update = (req,res,next)->
		req.user.pronoun = req.body.pronoun
		req.user.selfEval = req.body.selfEval
		req.user.save (err,user)->
			return next err if err?
			req.flash 'Your self eval has been added!'
			res.redirect '/'

	controller.edit = (req,res,next)->
		res.render 'selfEvals/edit', {user:req.user}

	controller