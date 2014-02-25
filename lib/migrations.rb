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

migration "create requests" do
  database.create_table :requests do
    primary_key :id
    foreign_key :app_id
    text        :secret
    text        :verb
    text        :path
    integer     :status
  end
end

migration "create endpoints" do
  database.create_table :endpoints do
    primary_key :id
    foreign_key :app_id
    text        :signature
  end
end
