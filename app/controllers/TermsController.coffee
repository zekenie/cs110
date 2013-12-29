module.exports = (app,config)->
	controller = {}
	controller.load = (req,res,next,id)->
		Terms.findById id, (err,term)->
			return next err if err?
			return res.send 404 if not term?
			req.term = term
			next()

	controller.view = [
		((req,res,next)->
			res.render "view"
			
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

	controller