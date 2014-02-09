#!/usr/bin/env node
require('newrelic');
require('coffee-script');
var train = require('express-train');

module.exports = train(__dirname);
setTimeout(function() {
	var _ = require('lodash');
	var mongoose = require('mongoose');
	mongoose.model('Hw_submissions').find({},"_id user",function(err,hw_submissions) {
		var submissions = _.groupBy(hw_submissions,"user");
		console.log(submissions);
		for(key in submissions) {
			console.log(key);
			var submissionIds = _.pluck(submissions[key],"_id")
			console.log(submissionIds);
			mongoose.model('Users').findByIdAndUpdate(key,{
				$addToSet:{
					hw_submissions:{
						$each:submissionIds
					}
				}
			},console.log);
		}
	});
},3000);
