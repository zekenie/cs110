# http = require 'http'

module.exports = (app, config) ->
	console.log "[express train application listening on #{config.port}]"
	app.listen config.port
	# server = http.createServer app
	# server.listen config.port