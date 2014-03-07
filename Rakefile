require "rake/testtask"

task :default => :test

desc "Seed data, start SSO session"
task :sso do
  require "./lib/ombudsman"
  options = { heroku_id: "test@localhost" }
  app = App.first(options) || App.create(options)
  app.endpoints_dataset.destroy
  Endpoint.create(app: app, verb: "get", signature: "/dashboard", health: "green")
  Endpoint.create(app: app, verb: "get", signature: "/login", health: "green")
  Endpoint.create(app: app, verb: "get", signature: "/logout", health: "red", health_msg: "18% error rate")
  Endpoint.create(app: app, verb: "post", signature: "/users", health: "green")
  Endpoint.create(app: app, verb: "put", signature: "/users/*", health: "yellow", health_msg: "increased 40x")
  Endpoint.create(app: app, verb: "get", signature: "/users/*/photo", health: "gray", health_msg: "not enough data")
  exec "kensa sso #{app.id}"
end

Rake::TestTask.new do |task|
  task.libs << "lib"
  task.libs << "test"
  task.name = :test
  task.test_files = FileList['test/*_test.rb']
end
