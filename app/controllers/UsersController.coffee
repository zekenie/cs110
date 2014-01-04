module.exports = (app,config)->
	controller = {}
	controller.load = (req,res,next,id)->
		Users.findById id, (err,user)->
			return next err if err?
			return res.send 404 if not user?
			req.reqUser = user
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
		(req,res,next)->
			return next() if req.user.id is req.reqUser.id or req.user.instructorOrTa
			res.send 400, "You're not authorized to see that profile."

		(req,res,next)->
			res.render "view",req.reqUser

	]

	controller