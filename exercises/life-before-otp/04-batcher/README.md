# Batcher

Use a receive loop to caputure all the incoming messages, and have the
process send itself a `:flush` message on an interval that will flush,
or process, the messages received in the window.

You can use `Process.send_after/1` set up the interval.
