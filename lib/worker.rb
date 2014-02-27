class Worker
  def start
    while true do
      work
    end
  end

  def work
    if pop = Cache.blpop("requests", timeout: 5)
      args = MultiJson.decode(pop.last)
      req  = Request.new(args)
      puts "read request #{req}"
      return unless app = req.app
      Aggregator.new(app, req).work!
    end
  rescue StandardError => e
    puts "WORKER FAILED: #{e.class.name} #{e.message}"
  end
end