#!/usr/bin/env node
// require('newrelic');
var CoffeeScript = require('coffee-script');
CoffeeScript.register();
var train = require('express-train');
// var fs = require('fs');

// var models_path = __dirname + '/models'
// fs.readdirSync(models_path).forEach(function (file) {
//   if (~file.indexOf('.coffee')) require(models_path + '/' + file)()
// })


module.exports = train(__dirname);
//setTimeout(function() {
// 	var _ = require('lodash');
// 	var mongoose = require('mongoose');
// 	mongoose.model('Hw_submissions').find({},"_id user",function(err,hw_submissions) {
// 		var submissions = _.groupBy(hw_submissions,"user");
// 		console.log(submissions);
// 		for(key in submissions) {
// 			console.log(key);
// 			var submissionIds = _.pluck(submissions[key],"_id")
// 			console.log(submissionIds);
// 			mongoose.model('Users').findByIdAndUpdate(key,{
// 				$addToSet:{
// 					hw_submissions:{
// 						$each:submissionIds
// 					}
// 				}
// 			},console.log);
// 		}
// 	});
// },3000);
