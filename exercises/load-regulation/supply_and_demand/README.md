# SupplyAndDemand

This project implement a GenStage pipeline with a producer, which has
a producer/consumer as a subscriber, which in turn has a consumer.

The consumer will start demanding events from the upstream after one
second.
