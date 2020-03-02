import Config

# queue_type: :sv_queue_ets or :sv_codel
# hz: the fequence the queue should get polled (in ms)
# rate: how many requests to produce when it poll the queue
#
# token_limit: how many to allow during a burst
# size: the number of jobs accepted before it starts shedding
# concurrency: how many jobs to run simultaneously

config :safetyvalve,
       [
         {:queues,
          [
            {:my_queue,
             [
               {:queue_type, :sv_codel},
               {:hz, 100},
               {:rate, 5},
               {:token_limit, 15},
               {:size, 280},
               {:concurrency, 5}
             ]}
          ]}
       ]
