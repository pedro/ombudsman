migration "create apps" do
  database.create_table :apps do
    primary_key :id
    text        :heroku_id
    text        :syslog_token
  end
end

class App < Sequel::Model
  def serialized
    {
      id: id,
      syslog_drain_url: ENV["LOG_DRAIN_URL"]
    }
  end
end
