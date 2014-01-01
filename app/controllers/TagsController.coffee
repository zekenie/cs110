module.exports = (app,config,Tags)->
	controller = {}
	controller.load = (req,res,next,id)->
		Tags.findById id, (err,tag)->
			return next err if err?
			return res.send 404 if not tag?
			req.tag = tag
			next()

	controller.view = [
		((req,res,next)->
			res.render "view"

		)
	]

	controller.index = [
		(req,res,next)->
			Tags.find {name:new RegExp req.query.q,'i','g'}, 'name createdAt', (err,tags) ->
				res.json tags
	]

	controller