passport = require 'passport'
module.exports = (app,DaysController,HwsController,UsersController,TermsController,IssuesController,TagsController)->

	auth = (req,res,next)->
		if req.isAuthenticated()
			app.locals.user = req.user
			next()
		else
			res.redirect '/login'

	app.get '/login',(req,res,next)->
		res.render 'login'

	app.get '/fb',passport.authenticate 'facebook'

	app.get '/fb/cb',passport.authenticate 'facebook',{successRedirect: '/',failureRedirect: '/login'}

	app.all '*',auth

	app.get '/logout',(req,res,next)->
		req.logout()
		res.redirect '/login'

	#--- Days ---#

	app.get '/',DaysController.index

	app.get '/day/new',DaysController.new

	app.post '/day',DaysController.create

	app.param 'dayId',DaysController.load

	#--- Hws ---#

	app.get '/hws',HwsController.index

	app.get '/hws/new',HwsController.new

	app.post '/hws',HwsController.create

	app.get '/hws/:hwId',HwsController.view

	app.put '/hws/:hwId',HwsController.update

	app.param 'hwId',HwsController.load

	#--- Users ---#

	app.get '/users',UsersController.index

	app.get '/users/new',UsersController.new

	app.post '/users',UsersController.create

	app.del '/users/:userId',UsersController.delete

	app.get '/users/:userId',UsersController.view

	app.param 'userId',UsersController.load

	#--- Terms ---#

	app.get '/terms/:termId',TermsController.view

	app.get '/terms/new',TermsController.new

	app.post '/terms',TermsController.create

	app.put '/terms/:termId',TermsController.update

	app.param 'termId',TermsController.load

	#--- Issues ---#

	app.get '/issues',IssuesController.index

	app.get '/issues/new',IssuesController.new

	app.post '/issues',IssuesController.create

	app.put '/issues/:issueId',IssuesController.update

	app.post '/issues/:issueId',IssuesController.comment

	app.param 'issueId',IssuesController.load

	#--- Tags ---#

	app.get '/tags/:tagId',TagsController.view

	app.param 'tagId',TagsController.load
