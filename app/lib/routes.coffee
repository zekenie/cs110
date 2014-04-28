passport = require 'passport'
module.exports = (app,DaysController,HwsController, Hw_submissionsController, SelfEvalController, UsersController,TermsController,IssuesController,TagsController,NotificationBlacklistsController,QuestionsController)->
	auth = (req,res,next)->
		if req.isAuthenticated()
			app.locals.loggedInUser = req.user
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

	app.get '/days/new',DaysController.new


	app.get '/days/:dayId',DaysController.view

	app.get '/days/:dayId/edit', DaysController.edit

	app.post '/days',DaysController.create

	app.del '/days/:dayId', DaysController.delete

	app.param 'dayId',DaysController.load

	#--- Hws ---#

	app.get '/hws',HwsController.index

	app.get '/hws/new',HwsController.new

	app.post '/hws',HwsController.create

	app.get '/hws/:hwId',HwsController.view

	app.post '/hws/:hwId', HwsController.submit

	app.put '/hws/:hwId',HwsController.update

	app.param 'hwId',HwsController.load

	#--- Hw_submissions ---#

	app.get '/hw_submissions/:hw_submissionId', Hw_submissionsController.view

	app.post '/hw_submissions/:hw_submissionId', Hw_submissionsController.comment

	app.put '/hw_submissions/:hw_submissionId', Hw_submissionsController.update

	app.param 'hw_submissionId', Hw_submissionsController.load

	#--- Users ---#

	app.get '/users/random', UsersController.random

	app.get '/users',UsersController.index

	app.put '/users/:userId',UsersController.update

	app.del '/users/:userId',UsersController.delete

	app.get '/users/:userId',UsersController.view

	app.get '/notifications',UsersController.notifications

	app.post '/clearNotifications',UsersController.clearNotifications

	app.param 'userId',UsersController.load

	#--- Self eval ---#

	app.get '/selfEval', (req,res)->
		res.redirect "/users/#{req.user.id}/selfEval"

	app.get '/users/:userId/selfEval', SelfEvalController.edit

	app.put '/users/:userId/selfEval', SelfEvalController.update

	#--- Notification Blacklist ---#

	app.post '/notificationBlacklists', NotificationBlacklistsController.create

	app.del '/notificationBlacklists/:notificationBlacklistId', NotificationBlacklistsController.delete

	app.param 'notificationBlacklistId',NotificationBlacklistsController.load

	#--- Terms ---#

	app.get '/terms/new',TermsController.new

	app.get '/terms/:termId/edit',TermsController.edit

	app.get '/terms/:termId',TermsController.view

	app.post '/terms',TermsController.create

	app.get '/terms',TermsController.index

	app.put '/terms/:termId',TermsController.update

	app.param 'termId',TermsController.load


	#--- Issues ---#

	app.get '/issues',IssuesController.index

	app.get '/issues/new',IssuesController.new

	app.get '/issues/:issueId', IssuesController.view

	app.post '/issues',IssuesController.create

	app.put '/issues/:issueId',IssuesController.update

	app.post '/issues/:issueId',IssuesController.comment

	app.param 'issueId',IssuesController.load

	#--- Tags ---#

	app.get '/tags',TagsController.index

	app.get '/tags/:tagId',TagsController.view

	app.param 'tagId',TagsController.load

	#--- Questions ---#

	app.get '/Questions',QuestionsController.index

