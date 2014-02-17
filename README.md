hedgy
=====

Use OANDA Rest API to accumulate positions

Usage
=======
```
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
	retries: 3
	retryDelaySeconds: 1

```

And account.json should look like this:
```
{
	"username" : "derthy",
	"password" : "Podrimt%",
	"accountId" : 6136751,
	"personalAccessToken": "xxx"
}


```
`personalAccessToken` can be ommitted if you are using the api-sandbox - otherwise get one here:
http://developer.oanda.com/docs/v1/auth/

