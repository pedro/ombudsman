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
- REDIS!
