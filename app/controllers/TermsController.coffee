module.exports = (app,config)->
	controller = {}

	controller.load = (req,res,next,id)->
		Terms.findById id, (err,term)->
			return next err if err?
			return res.send 404 if not term?
			req.term = term
			next()

	controller.index = [
		(req,res,next)->
			Terms.search req.query.q, (err,terms)->
				res.render 'terms/index', {terms:terms}
	]

	controller.view = [
		(req,res,next)->
			res.render "terms/view", {term:req.term}

	]

	controller.new = [
		(req,res,next)->
			res.render "terms/new"
	]

	parseTags = (req,res,next)->
		req.tags = req.body.tags.split ','
		delete req.body.tags
		next()

	controller.create = [
		parseTags
		(req,res,next)->
			description = req.body.description
			req.body.description = ''
			term = new Terms req.body
			term = term.changeDescription req.user, description
			term.tag req,tags, (err,term)->
				term.save (err,term)->
					return next err if err?
					res.redirect '/terms'

	]

	controller.update = [
		parseTags
		(req,res,next)->
			description = req.body.description
			delete req.body.description
			req.term = req.term.changeDescription req.user, description
			for k,v of req.body
				req.term[k] = v
			req.term.tag req,tags, (err,term)->
				term.save (err,term)->
					return next err if err?
					res.redirect '/terms/' + term.id
	]

	controller