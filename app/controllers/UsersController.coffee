module.exports = (app,config,Users,tagHelper)->
	controller = {}
	controller.load = (req,res,next,id)->
		Users.findById(id).populate('issues issueContributions').exec (err,user)->
			return next err if err?
			return res.send 404 if not user?
			user = user.toObject {getters:true, virtuals:true}
			tagHelper.deepPopulate 'Issues','issue',user,(err,user)->
				return next err if err?
				req.reqUser = user
				next()

	controller.index = [
		(req,res,next)->
			return next() if req.user.instructorOrTa
			res.send 400
		(req,res,next)->
			Users.find {}, (err,users)->
				return next err if err?
				res.render "users/index", {users:users}

	]

	controller.delete = [
		(req,res,next)->
			res.json {}
	]

	controller.view = [
		(req,res,next)->
			return next() if req.user.id is req.reqUser.id or req.user.instructorOrTa
			res.send 400, "You're not authorized to see that profile."

		(req,res,next)->
			res.render "users/view",req.reqUser

	]

	controller