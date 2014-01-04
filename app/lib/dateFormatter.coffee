moment = require 'moment'

format = 'YYYY-MM-DD HH:mm'

module.exports = ()->
	fns = {}

	fns.get = (d)->
		moment(d).format format

	fns.set = (d)->
		moment(d, format)._d

	fns.addon = (schema,options)->
		schema.virtual('createdAt').get ->
			moment(@_id.getTimestamp()).format format

		schema.add {updatedAt:{type:Date,get:fns.get}}

		schema.pre 'save', (next)->
			updatedAt = new Date()
			next()


	fns