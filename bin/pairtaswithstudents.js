#! /usr/bin/env node
require('coffee-script');
var dateFormatter = require('../app/lib/dateFormatter.coffee')();
var config = {
    "mongoUri":"mongodb://localhost/cs110",
    "request_timeout":2200,
    "port":"{{PORT}}",
    "character_encoding":"utf-8",
    "twilio":{
        "sid":"ACc21b28a9096139edbc9c129e7a05a4e5",
        "authToken":"29b89b1f43243100fd53f7ff6697c0c3",
        "phone":"+14139313184"    
    },
    "postmark":"{{POSTMARK}}"
};
var mongoose = require('mongoose');
ObjectId = mongoose.Types.ObjectId;
var _ = require('lodash');
//Borrowed From 
//http://stackoverflow.com/questions/6274339/how-can-i-shuffle-an-array-in-javascript
function shuffle(o){ //v1.0
        for(var j, x, i = o.length; i; j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
        return o;
};
mongoose.connect(config.mongoUri);
require('../app/models/Users')(dateFormatter, config, require("../app/models/NotificationBlacklists.coffee")(dateFormatter, config));
mongoose.model('Users').find({},'_id assigned_students role').exec(function(err, data){
    var groupedClass =  _.groupBy(data,'role');
    var tas = groupedClass.ta;
    var shuffledStudents = shuffle(groupedClass.student);
    var studentsPerTa = shuffledStudents.length/tas.length;
    console.log(shuffledStudents.pop()._id);
    for(var i = 0; i < tas.length; ++i){
        tas[i].assigned_students = [];
        for(var o = 0; o<studentsPerTa; ++o){
            if(shuffledStudents.length > 0){
                tas[i].assigned_students.addToSet(shuffledStudents.pop()._id);
            }
        }
        tas[i].save(function(err,data){
            if(data){
                console.log("saved: ", data);
            }else{
                console.log("err");
            }
        });
    }
});
