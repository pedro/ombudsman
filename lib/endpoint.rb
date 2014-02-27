class Endpoint < Sequel::Model
  many_to_one :app

  def stats=(s)
    super(Sequel.hstore(s))
    self.stats_collected_at = Time.now
  end
end
