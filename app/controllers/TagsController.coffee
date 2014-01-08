_ = require 'lodash'
module.exports = (app,config,Tags)->
	controller = {}
	controller.load = (req,res,next,id)->
		Tags.findById(id).populate('days hw terms issues').exec (err,tag)->
			return next err if err?
			return res.send 404 if not tag?
			req.tag = tag
			next()

	controller.view = [
		(req,res,next)->
			res.render "tags/view",req.tag

	]

	controller.index = [
		(req,res,next)->
			query = {}
			query.name = new RegExp req.query.q,'i','g' if req.query.q?
			Tags.find query, 'name createdAt', (err,tags) ->
				accepts = req.accepts 'html','json'
				return res.json tags if accepts is 'json'
				res.render 'tags/index',{tags:tags}
	]

	controller