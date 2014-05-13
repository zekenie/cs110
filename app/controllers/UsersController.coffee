async = require 'async'
_ = require 'lodash'

module.exports = (app,config,tagHelper,Users)->
	controller = {}
	controller.load = (req,res,next,id)->
		Users.findById(id).populate('issues issueContributions eval.comments.user').exec (err,user)->
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
			Users.studentsWithHw {}, (err,studentsAndHw)->
				return next err if err?
				res.render "users/index", {students:JSON.stringify(studentsAndHw.students),hws:JSON.stringify(studentsAndHw.hws)}
	]

	controller.notifications = [
		(req,res,next)->
			req.user.newestNotifications 8, (records)->
				res.render 'users/notifications', {notifications:records}
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
            if req.reqUser.instructorOrTa
                Users.studentsWithHw {_id: {$in: req.reqUser.assigned_students}}, (err, studentsAndHw)->
                    req.reqUser.hws = JSON.stringify(studentsAndHw.hws)
                    req.reqUser.students = JSON.stringify(studentsAndHw.students)
                    res.render "users/view", req.reqUser
            else
                req.reqUser.allHws (err,hws)->
                    return next err if err?
                    req.reqUser.hws = hws
                    res.render "users/view",req.reqUser
	]

	controller
