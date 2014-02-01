_ = require 'lodash'
async = require 'async'

module.exports = (Users)->
	(schema,options)->
		schema.methods.notify = (omit,cb)->
			toNotify = []
			user = @user.id or @user
			toNotify.push user
			for comment in @comments
				toNotify.push comment.user.id or comment.toString()
			toNotify.pop()
			toNotify = _.without toNotify, omit.toString()
			Users.notifyByIds toNotify, @commentNotification,@constructor.modelName,@id,cb

		schema.methods.comment = (comment,cb)->
			@comments.push comment
			@save (err,issue)->
				return cb err if err?
				issue.notify comment.user, cb