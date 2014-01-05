_ = require 'lodash'
module.exports = (app,config,Hws,Days,dateFormatter)->
	controller = {}
	controller.load = (req,res,next,id)->
		Hws.findById id, (err,hw)->
			return next err if err?
			return res.send 404 if not hw?
			req.hw = hw
			next()

	controller.index = [
		(req,res,next)->
			Hws.find({}).populate('tags').exec (err,hws)->
				return next err if err?
				hws = hws.map (hw)->
					hw = hw.toObject {virtuals:true}
					hw.dateAssigned = dateFormatter.get hw.dateAssigned
					hw.dateDue = dateFormatter.get hw.dateDue
					hw
				res.render "hws/index",{hws:hws}

	]

	controller.new = [
		(req,res,next)->
			return next() if req.user.instructor
			res.send 400, 'You\'re not authorized to make homework assignments'
		(req,res,next)->
			Days.getDaysList {}, (err,daysHash)->
				res.render "hws/new",{daysHash:daysHash}
	]

	controller.create = [
		(req,res,next)->
			req.body.checklist = req.body.checklist.split "\r\n"
			req.tags = req.body.tags.split ','
			delete req.body.tags
			next()
		(req,res,next)->
			hw = new Hws req.body
			hw.tag req.tags, (err,hw)->
				return next err if err?
				hw.save (err,hw)->
					return next err if err?
					res.json hw
	]

	controller.view = [
		(req,res,next)->
			res.render "hws/view"

	]

	controller.update = [
		(req,res,next)->
			req.hw = _.extend req.hw,req.body
			req.hw.save (err,hw)->
				return next err if err?
				res.json hw
	]

	controller