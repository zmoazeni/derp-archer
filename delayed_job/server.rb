module DelayedJob
  class Server < Sinatra::Base
    post "/enqueue" do
      request.body.rewind
      job = MultiJson.load(request.body)
      request.body.rewind

      Qu.enqueue(job["klass"], job["args"])
      [202, {"Content-Type" => "application/json"}, ""]
    end
  end
end
