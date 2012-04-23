A basic prototype of a rewrite of DelayedJob includes these concepts:

* Ripping out AR/Mongo/etc and using [leveldb](http://code.google.com/p/leveldb/) as the sole backend
* Reusing [Qu's](https://github.com/bkeepers/qu) existing architecture
  (though I'm already starting to depart from his initial design)
* 1 fork per job (inefficient, but hey upgrade to something else if you need more)
* Using dRB to enqueue jobs (not implemented yet)
