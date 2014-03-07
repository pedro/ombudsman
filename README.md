# Ombudsman

Heroku add-on that sits and inspects your logs, alerting when it detects a spike in error rates for your RESTful API.


## Usage

Install:

```bash
$ heroku addons:add ombudsman
```

Then give it some time and check the dashboard:

```bash
$ heroku addons:open ombudsman
```

To see something like:

![Ombudsman Dashboard](http://f.cl.ly/items/1t0F2v0V1s2A1n192u3A/Screen%20Shot%202014-03-06%20at%206.05.04%20PM.png)

The idea is that you'll receive email with alerts whenever your error rates change drastically.


## Development

You'll need Postgres and Redis.

```bash
$ createdb ombudsman-test
$ createdb ombudsman
$ bundle install
$ cp .env.sample .env
$ rake
$ foreman start
```

To deploy as a new add-on:

```bash
$ cp sample-addon-manifest.json addon-manifest.json
# change .env
$ kensa test
$ kensa push
```


## TODO

- More flexible route information
  - Allow users to update their own route signatures
- Add alerting:
  - Compare measurement records: if non 20x and 30x rate grows over a certain threshold in the last X minutes, alert
