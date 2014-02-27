# Ombudsman

Heroku add-on that sits and inspects your logs, alerting when it detects a spike in error rates for your RESTful API.

## Usage

Install:

```
$ heroku addons:add ombudsman
```

Then you'll receive an email whenever your app error rates change drastically!


## TODO

- More flexible route information
  - Allow users to update their own route signatures
- Add alerting:
  - Compare measurement records: if non 20x and 30x rate grows over a certain threshold in the last X minutes, alert