migration "create apps" do
  database.create_table :apps do
    primary_key :id
    text        :heroku_id
    text        :syslog_token
  end
end

migration "add drain_secret" do
  database.add_column :apps, :drain_secret, :text
end

class App < Sequel::Model
  def before_create
    self.drain_secret ||= SecureRandom.hex(8)
  end

  def log_drain_url
    ENV["LOG_DRAIN_URL"] + "/#{id}/#{drain_secret}"
  end

  def serialized
    {
      id: id,
      syslog_drain_url: log_drain_url
    }
  end
end
