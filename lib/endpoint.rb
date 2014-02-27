class Endpoint < Sequel::Model
  many_to_one :app
end
