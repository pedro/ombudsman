Sequel.extension :pg_hstore

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

migration "create endpoints" do
  database.create_table :endpoints do
    primary_key :id
    foreign_key :app_id
    text        :signature
  end
end

migration "add hstore" do
  database.run "CREATE EXTENSION hstore;"
end

migration "add stats to endpoints" do
  database.add_column :endpoints, :stats, :hstore
  database.add_column :endpoints, :stats_collected_at, :timestamp
end

migration "index" do
  database.add_index :endpoints, :app_id
end

migration "add health" do
  database.add_column :endpoints, :health, :text
end