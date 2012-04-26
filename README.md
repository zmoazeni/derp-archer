# A basic prototype of a rewrite of DelayedJob that includes these concepts:

Basically it keeps the same essence of what I think makes DJ great: "small and simple to get started and run". It also rips out a large swath of dependencies that makes maintenance tougher. It retains a Resque-like API to let the codebase upgrade to another Qu backend/Resque/Sidekiq when their app needs more power.

* Ripping out AR/Mongo/etc and using [leveldb](http://code.google.com/p/leveldb/) as the sole backend
* Reusing [Qu's](https://github.com/bkeepers/qu) existing architecture
  (though I'm already starting to depart from his initial design)
* 1 fork per job with a maximum number of workers (inefficient, but
  hey upgrade to something else if you need more) - won't allow
  spreading workers among machines.
* Using sinatra/thin to enqueue jobs

# To Run with a sample worker

    bundle
    bundle exec ruby -I. ./playing/test_worker.rb

# How it works

The architecture is laid out like this:

  - Only one process is started by the user.
    - From Qu's perspective, this is 1 "worker" (see below)
  - The library wraps Qu overriding a Qu::Worker, and the user uses
    DelayedJob.configure
  - The library implements a Qu backend that acts as backend interface
    to 3 separate leveldb databases (queued, running, failed)
    - These are lightweight dbs that are treated more like
      collections.
    - If you haven't used leveldb before, it's essentially a
      persistent hash with sorted keys
    - Only one process can open a leveldb database at once, which is
      influencing some of software design
  - The library mostly follow's Qu's conventions however the worker
    isn't actually doing the work. The worker will fork a process per
    job (with a maximum number of children).
      - The maximum children lets us keep the memory footprint bounded
      - Forking 1 process per job (a la resque) is inefficient however
        it's efficient enough for DJ
      - Forking per job also avoids memory leaks that may arise from
        the app. The child will take any memory hits and then dies/releases memory at
        the end of the job.
      - (Potential feature: adding a sinatra/server route that lets
        you change the maximum number of children at runtime)
  - The worker will also start a sinatra app using thin. This is actually how jobs are enqueued
    - This could be a fully fledged JSON API which allows a user to inspect the queue, running jobs, failed jobs, etc.
  - Benefits of depending on Qu:
    - Simple codebase. We don't need to maintain a full front-end
    - Qu/Resque/Sidekiq use a very similiar API. So someone starting
       with DelayedJob wouldn't have to change much to swap out a
       different architecture
    - We can reuse Qu plugins such as Error handlers
  - Benefits of depending on LevelDB
    - No longer depend on MySQL or Mongo for managing the queue (I
       should benchmark leveldb, but my intuition is that it's much faster)
    - It separates and simplifies our storage. We no longer need to
      provide a mysql migration or maintain our
      connection with ActiveRecord or MongoMapper
  - Using Qu and LevelDB, people can use DelayedJob on non-Rails
     projects
  - Downsides: 
    - the current front-end for delaying jobs is slick
    - We can't split workers among boxes. This may become a line in the
     sand to prompt people to upgrade to a different background
     processor

# What is with the repo name?

I just chose a name that github provided :)
