require "thin"

app = proc do |env|
  [
   200,          # Status code
   {             # Response headers
     'Content-Type' => 'text/html',
     'Content-Length' => '2',
   },
   ['hi']        # Response body
  ]
end

Thin::Server.start('0.0.0.0', 3000) do
  map "/lobster" do
    run app
  end
end
