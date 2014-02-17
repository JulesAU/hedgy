hedgy
=====

Use OANDA Rest API to accumulate positions

Usage
=======
```
npm install
./buy.coffee  --account ./account.json  --options ./options.json 
```

options.json should look like this:
```
{
	"apiEndpoint": "http://api-sandbox.oanda.com/",
	"spreadLimitPips": 3.5,
	"currencyPair": "AUD_USD",
	"units": 1000
}

with optional params of:
	invertUnits: false
	retries: 3
	retryDelaySeconds: 1

```

   * If **invertUnits** is true, we divide units by the rate - so we're choosing how much of the short currency to sell, instead of how much of the long currency to buy

And account.json should look like this:
```
{
	"accountId" : 6136751,
	"personalAccessToken": "xxx"
}


```
`personalAccessToken` can be ommitted if you are using the api-sandbox - otherwise get one here:
http://developer.oanda.com/docs/v1/auth/

