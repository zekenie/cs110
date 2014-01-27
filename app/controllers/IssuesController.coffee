pagedown = require 'pagedown'
moment = require 'moment'
_ = require 'lodash'
module.exports = (app,config,Issues)->
	controller = {}
	controller.load = (req,res,next,id)->
		Issues.findById(id).populate('user day hw tags assignedTo comments.user').exec (err,issue)->
			return next err if err?
			return res.send 404 if not issue?
			issue.mine = issue.user.equals req.user
			req.issue = issue
			next()

	controller.index = [
		(req,res,next)->
			console.log req.query
			req.query.open = req.query.open or true
			Issues.find(req.query).populate('user day hw tags assignedTo').exec (err,issues)->
				return next err if err?
				res.render "issues/index",{issues:issues}

	]

	controller.view = [
		((req,res,next)->
			res.render "issues/view",req.issue
		)
	]

	controller.new = [
		((req,res,next)->
			res.render "issues/new",req.query
		)
	]

	controller.create = [
		((req,res,next)->
			req.tags = req.body.tags.split ','
			delete req.body.tags
			next()
		),
		((req,res,next)->
			req.body.user = req.user.id
			issue = new Issues req.body
			issue.tag req.tags, (err,issue)->
				return next err if err?
				issue.save (err,issue)->
					return next err if err?
					res.redirect "/issues/#{issue.id}"
		)
	]

	controller.update = [
		(req,res,next)->
			for k,v of req.body
				req.issue[k] = v
			req.issue.save (err,issue)->
				res.redirect '/issues/#{issue.id}'
	]

	controller.comment = [
		(req,res,next)->
			req.body.user = req.user._id
			req.issue.comments.push req.body
			req.issue.save (err,issue)->
				return next err if err?
				issue.notify req.user._id, (err,notifyRes)->
					return next err if err?
					res.redirect '/issues/' + issue.id

					# if this isn't the users issues, add it to their issue contribution
					if req.user._id isnt req.issue.user._id
						req.user.issueContributions.push req.issue._id
						req.user.save()
	]

	controller