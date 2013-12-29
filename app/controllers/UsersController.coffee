module.exports = (app,config)->
	controller = {}
	controller.load = (req,res,next,id)->
		Users.findById id, (err,user)->
			return next err if err?
			return res.send 404 if not user?
			req.user = user
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

	controller.delete = [
		((req,res,next)->
			
			res.json {}
		)
	]

	controller.view = [
		((req,res,next)->
			res.render "view"
			
		)
	]

	controller