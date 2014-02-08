module.exports = (app,config,Users,tagHelper)->
	controller = {}
	controller.load = (req,res,next,id)->
		Users.findById(id).populate('issues issueContributions').exec (err,user)->
			return next err if err?
			return res.send 404 if not user?
			req.user.mine = req.user.equals user
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

	controller.notifications = [
		(req,res,next)->
			req.user.notifications.reverse()
			res.render 'users/notifications', {user:req.user}
	]

	controller.random = (req,res,next)->
		Users.random (err,user)->
			return next err if err?
			res.redirect "/users/#{user.id}"

	controller.clearNotifications = (req,res,next)->
		req.user.viewNotifications (err)->
			return next err if err?
			res.send 200


	controller.update = [
		(req,res,next)->
			return next() if req.user.instructorOrTa or req.user.mine
			res.send 400
		(req,res,next)->
			for k,v of req.body
				req.reqUser[k] = v
			req.reqUser.save (err,user)->
				return next err if err?
				req.flash 'Done!'
				res.redirect "/users/#{user.id}"
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
			req.reqUser.allHws (err,hws)->
				return next err if err?
				req.reqUser.hws = hws
				res.render "users/view",req.reqUser
	]

	controller