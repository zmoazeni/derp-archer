require 'drb/drb'

# The URI for the server to connect to
URI="druby://localhost:8787"

class TimeServer

  def get_current_time
    puts "received and started to sleep"
    sleep 6
    return Time.now
  end

end

# The object that handles requests on the server
FRONT_OBJECT=TimeServer.new

$SAFE = 1   # disable eval() and friends

DRb.start_service(URI, FRONT_OBJECT)
# Wait for the drb server thread to finish before exiting.
DRb.thread.join
