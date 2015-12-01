#!/usr/bin/env  ./node_modules/.bin/coffee
argv = require('minimist')(process.argv.slice 2)

options = require argv['options']
account = require argv['account']

Buyer = require('./lib/buyer').Buyer

defaults =
	retries: 3
	retryDelaySeconds: 1
	invertUnits: false
	operation: "buy"

for key, val of defaults
	if not options[key]? then options[key] = val

attempt = (callback) ->
	buyer = new Buyer options, account
	buyer.execute (error, result) ->
		if not error
			spread = Math.round ((result.offeredPrices.ask - result.offeredPrices.bid) * 100000)
			process.stdout.write "Purchased #{ result.tradeOpened.units } units of #{ result.instrument } \
			@ #{ result.price } after offer of #{ result.offeredPrices.ask } and spread of #{ spread } \n"
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


