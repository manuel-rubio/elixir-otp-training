# Echo

Implement an Echo server that send whatever message it get back to the
process that send it.

Public functions to implement

- `start()` -> `pid` :: start an Echo server and return its pid

- `bounce(server_pid, message)` -> `:ok` :: send a term to the echo
  server, which should send the term back to the sender (hint: use
  `self()` in the client call and pass it along to the echo server so
  it know where to send the message back to.

- `stop(server_pid)` -> `:ok` :: should stop the server

Note: You are not allowed to use any OTP Behaviour to solve this
exercise, only the basic Elixir functions such as `receive/1` and
`send/2`, and of course functions.
