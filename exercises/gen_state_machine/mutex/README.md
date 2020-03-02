# Mutex

Implement the Mutex lock we implemented earlier in the course but this
time do it as a proper OTP finite-state-machine using the
GenStateMachine behaviour.

GenStateMachine is an Elixir wrapper for the Erlang OTP `:gen_statem`
behaviour, it is included in the mix file, but you might have to run a
`mix deps.get` in your project for it to work.

A application structure is provided, as well as a unit test that start
out as being skipped. Furthermore a scaffold for a GenStateMachine has
been provided and configured to use handle event functions.
