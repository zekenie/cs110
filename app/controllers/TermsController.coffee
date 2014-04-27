module.exports = (app,config,Terms)->
	controller = {}

	controller.load = (req,res,next,id)->
		Terms.findById(id).populate('tags').exec (err,term)->
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
			res.render "terms/view", {term:req.term,descriptionMd:req.term.getDescriptionMd()}

	]

	controller.edit = [
		(req,res,next)->
			res.render "terms/edit", {term:req.term}

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
		(req,res,next)->
			Terms.findOne {name: req.body.name.toLowerCase()}, (err,term)->
				return next err if err?
				return next() if not term?
				res.redirect "/terms/#{term.id}"
		parseTags
		(req,res,next)->
			term = new Terms req.body
			term.tag req.tags, (err,term)->
				return next err if err?
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
			req.term.tag req.tags, (err,term)->
				return next err if err?
				term.save (err,term)->
					return next err if err?
					res.redirect '/terms/' + term.id
	]

	controller