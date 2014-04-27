module.exports = (app,NotificationBlacklists)->
	# NotificationBlacklists = mongoose.model 'NotificationBlacklists'
	controller = {}
	controller.load = (req,res,next,id)->
		NotificationBlacklists.findById(id).exec (err,notificationBlacklist)->
			return next err if err?
			return res.send 404 if not notificationBlacklist?
			req.notificationBlacklist = notificationBlacklist
			next()

	controller.delete = [
		(req,res,next)->
			req.notificationBlacklist.remove (err)->
				return next err if err?
				res.send 201
	]

	controller.create = [
		(req,res,next)->
			NotificationBlacklists.findOrCreate req.body, (err,notificationBlacklist)->
				return next err if err?
				res.json notificationBlacklist
	]


	controller