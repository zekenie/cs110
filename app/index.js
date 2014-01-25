#!/usr/bin/env node
require('newrelic');
require('coffee-script');
var train = require('express-train');

module.exports = train(__dirname);