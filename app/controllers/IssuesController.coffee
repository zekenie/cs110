pagedown = require 'pagedown'
moment = require 'moment'
module.exports = (app,config,Issues)->
	controller = {}
	controller.load = (req,res,next,id)->
		Issues.findById(id).populate('user day hw tags assignedTo comments.user').exec (err,issue)->
			return next err if err?
			return res.send 404 if not issue?
			req.issue = issue
			next()

	controller.index = [
		((req,res,next)->
			res.render "issues/index"
		)
	]

	controller.view = [
		((req,res,next)->
			req.issue = req.issue.toObject()
			req.issue.description = pagedown.getSanitizingConverter().makeHtml req.issue.description
			req.issue.createdAt = moment(req.issue.createdAt).format app.get 'dateFormat'
			res.render "issues/view",req.issue
		)
	]

	controller.new = [
		((req,res,next)->
			res.render "issues/new"
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
		((req,res,next)->

			res.json {}
		)
	]

	controller.comment = [
		((req,res,next)->


		)
	]

	controller