pagedown = require 'pagedown'
module.exports = ()->
	fns = {}
	fns.get = (s)-> pagedown.getSanitizingConverter().makeHtml s

	fns