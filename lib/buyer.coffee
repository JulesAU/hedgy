request = require 'request'

exports.Buyer =
class Buyer
	constructor: (@options, @account) ->

	execute: (callback) =>
		@_verifySpread (error) =>
			if error
				callback error
			else
				@_openTrade callback

	_verifySpread: (callback) =>
		options = 
			uri: @options.apiEndpoint + "v1/quote?instruments=" + @options.currencyPair
		
		if @account.personalAccessToken
			options.headers = 
				"Authorization": "Bearer " + @account.personalAccessToken

		request options, (error, response, body) =>
			callback error if error
			if response.statusCode != 200
				return callback "API error: " + body

			body = JSON.parse body
			prices = body.prices[0]
			if prices.instrument != @options.currencyPair
				return callback "Expected #{ @options.currencyPair } but got #{ prices.instrument }!"

			spreadPips = (prices.ask - prices.bid) * 10000
			if spreadPips > @options.spreadLimitPips
				return callback "Offered spread of #{ spreadPips } exceeds our limit of #{ @options.spreadLimitPips }"

			callback null

	_openTrade: (callback) =>
		data =
			instrument: @options.currencyPair
			units: @options.units
			side: 'buy'
			type: "market"

		request
			uri: @options.apiEndpoint + "v1/accounts/#{ @account.accountId }/orders"
			method: "POST"
			form: data
		, (error, response, body) =>
			callback error if error

			if response.statusCode != 200
				return callback "API error: " + body

			result = JSON.parse body

			if result.instrument != @options.currencyPair
				return callback "Opened order of wrong currency pair " + body

			if result.tradeOpened.units != @options.units
				return callback "The #{ @options.units } requested units were not filled in order " + body

			callback null, result


