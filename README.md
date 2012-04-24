A basic prototype of a rewrite of DelayedJob includes these concepts:

* Ripping out AR/Mongo/etc and using [leveldb](http://code.google.com/p/leveldb/) as the sole backend
* Reusing [Qu's](https://github.com/bkeepers/qu) existing architecture
  (though I'm already starting to depart from his initial design)
* 1 fork per job with a maximum number of workers (inefficient, but
  hey upgrade to something else if you need more) - won't allow
  spreading workers among machines.
* Using dRB (or possibly a threaded sinatra app) to enqueue jobs (not implemented yet)

Basically it keeps the same essence of what I think makes DJ great: "small and simple to get started and run". It also rips out a large swath of dependencies that makes maintenance tougher. It retains a Resque-like API to let the codebase upgrade to another Qu backend/Resque/Sidekiq when their app needs more power. It won't allow multiple workers among multiple machines. It would allow you to use DJ on non-rails projects.
