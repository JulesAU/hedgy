#!/usr/bin/env  ./node_modules/.bin/coffee
argv = require('minimist')(process.argv.slice 2)

options = require argv['options']
account = require argv['account']

Buyer = require('./lib/buyer').Buyer

defaults =
	retries: 3
	retryDelaySeconds: 1

for key, val of defaults
	if not options[key]? then options[key] = val

attempt = (callback) ->
	buyer = new Buyer options, account
	result = buyer.execute (error, result) ->
		if not error
			process.stdout.write "Purchased #{ result.tradeOpened.units } units of #{ result.instrument } @ #{ result.price }\n"
		callback error, result


attemptCallback = (error, result) ->
	if error
		process.stderr.write error + "\n"
		if options.retries-- > 0
			process.stdout.write "Retries remaining: #{ options.retries }...\n"
			setTimeout ->
				attempt attemptCallback
			, options.retryDelaySeconds * 1000
		else
			process.stderr.write "Exceeded retries; failing\n"
			process.exit 1
	else
		process.exit 0


attempt attemptCallback


