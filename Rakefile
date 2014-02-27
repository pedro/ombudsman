require "rake/testtask"

task :default => :test
task :sso do
  require "./lib/ombudsman"
  options = { heroku_id: "test@localhost" }
  app = App.first(options) || App.create(options)
  app.endpoints_dataset.destroy
  Endpoint.create(app: app, verb: "get", signature: "/dashboard", health: "green")
  Endpoint.create(app: app, verb: "get", signature: "/login", health: "green")
  Endpoint.create(app: app, verb: "get", signature: "/logout", health: "red")
  Endpoint.create(app: app, verb: "post", signature: "/users", health: "green")
  Endpoint.create(app: app, verb: "put", signature: "/users/\\d+", health: "yellow")
  Endpoint.create(app: app, verb: "get", signature: "/users/\\d+/photo", health: "gray")
  t = Time.now
  signature = [app.id, ENV["SSO_SALT"], t.to_i].join(":")
  token = Digest::SHA1.hexdigest(signature)
  puts "/#{app.id}?token=#{token}&timestamp=#{t.to_i}"
end

Rake::TestTask.new do |task|
  task.libs << "lib"
  task.libs << "test"
  task.name = :test
  task.test_files = FileList['test/*_test.rb']
end
