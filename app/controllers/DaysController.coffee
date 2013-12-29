module.exports = (app,config,Days)->
	controller = {}
	controller.load = (req,res,next,id)->
		Days.findById id, (err,day)->
			return next err if err?
			return res.send 404 if not day?
			req.day = day
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
			Days.create req.body, (err,day)->
				return next err if err?
				res.json day
		)
	]

	controller