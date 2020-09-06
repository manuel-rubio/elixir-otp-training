# Rpn

A GenServer that implement a reverse polish notation calculator

Should have a public interface that implement a

- start_link() -> {:ok, pid} | ...
- stop(pid) -> :ok
- push(pid, token) -> {:ok, result} | ...

Push will send a token to the RPN process, and it should return the
result to the client.

A test suite is provided in the test-folder. The tests has been marked
as skipped; remove this tag ask you implement the RPN server.
