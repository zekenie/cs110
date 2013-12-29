_ = require 'lodash'
module.exports = (app,config,Hws)->
	controller = {}
	controller.load = (req,res,next,id)->
		Hws.findById id, (err,hw)->
			return next err if err?
			return res.send 404 if not hw?
			req.hw = hw
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
			Hws.create req.body,(err,hw)->
				return next err if err?
				res.json hw
		)
	]

	controller.view = [
		((req,res,next)->
			res.render "view"

		)
	]

	controller.update = [
		((req,res,next)->
			req.hw = _.extend req.hw,req.body
			req.hw.save (err,hw)->
				return next err if err?
				res.json hw
		)
	]

	controller