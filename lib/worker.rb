class Worker
  def start
    while true do
      work
    end
  end

  def work
    if pop = Cache.blpop("requests", timeout: 30)
      args = MultiJson.decode(pop.last).with_indifferent_access
      puts "read request #{args.inspect}"
      req  = Request.new(args)
      return unless app = req.app
      endpoint = Aggregator.new(app, req).work!
      Stats.record(endpoint, req.status)
    end
  rescue StandardError => e
    puts "WORKER FAILED: #{e.class.name} #{e.message}"
  end
end