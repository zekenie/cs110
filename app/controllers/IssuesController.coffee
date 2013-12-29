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
			res.render "index"
			
		)
	]

	controller.new = [
		((req,res,next)->
			res.render "new"
			
		)
	]

	controller.create = [
		((req,res,next)->
			
			res.json {}
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