# Ombudsman

Heroku add-on that sits and inspects your logs, alerting when it detects a spike in error rates for individual endpoints.

## Usage

Install:

```
$ heroku addons:add ombudsman
```

Then you'll receive an email whenever your app error rates change drastically!


## TODO

- More flexible route information
  - Allow users to update their own route signatures
- Throw requests in REDIS!
- Create new measurement redis-backed model
  - For every window of X minutes, store status codes and their counts (eg: 200: 4, 422: 2, 500: 1)
- Add alerting:
  - Compare measurement records: if non 20x and 30x rate grows over a certain threshold in the last X minutes, alert