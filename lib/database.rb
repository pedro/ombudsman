migration "create apps" do
  database.create_table :apps do
    primary_key :id
    text        :heroku_id
  end
end

class App < Sequel::Model
  def serialized
    {
      id: id
    }
  end
end
