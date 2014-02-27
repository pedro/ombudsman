class Endpoint < Sequel::Model
  many_to_one :app

  def stats=(s)
    super(Sequel.hstore(s))
    self.stats_collected_at = Time.now
  end

  # override to to_i keys and values
  # "200" => "1" becomes 200 => 1
  def stats
    unformatted = super
    return {} unless unformatted
    unformatted.inject({}) do |h, (k, v)|
      h[k.to_i] = v.to_i
      h
    end
  end
end
