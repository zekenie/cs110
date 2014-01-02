module.exports = (app,config)->
	controller = {}
	controller.load = (req,res,next,id)->
		Issues.findById id, (err,issue)->
			return next err if err?
			return res.send 404 if not issue?
			req.issue = issue
			next()

	controller.index = [
		((req,res,next)->
			res.render "issues/index"

		)
	]

	controller.new = [
		((req,res,next)->
			res.render "issues/new"

		)
	]

	controller.create = [
		((req,res,next)->
			req.tags = req.body.tags.split ','
			delete req.body.tags
			next()
		),
		((req,res,next)->
			issue = new Issues req.body
			issue.tag req.tags, (err,issue)->
				return next err if err?
				issue.save (err,issue)->
					return next err if err?
					res.json issue
		)
	]

	controller.update = [
		((req,res,next)->

			res.json {}
		)
	]

	controller.comment = [
		((req,res,next)->


		)
	]

	controller