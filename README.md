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

![Ombudsman Dashboard](http://f.cl.ly/items/0O2g0k0c3K1O3Q3g3M0y/Screen%20Shot%202014-02-27%20at%203.18.23%20AM.png)

The idea is that you'll receive email with alerts whenever your error rates change drastically.


## Development

You'll need Postgres and Redis.

```bash
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
