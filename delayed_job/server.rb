module DelayedJob
  class Server < Sinatra::Base
    get "/foo" do
      "Hullo there!"
    end
  end
end
